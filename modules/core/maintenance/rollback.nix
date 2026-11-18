{ ... }:
{
  # imported by auto-upgrade, which also brings the health module
  flake.nixosModules.rollback =
    { config, lib, ... }:
    let
      state = "/var/lib/auto-upgrade";
      profile = "/nix/var/nix/profiles/system";

      # where systemd-boot's entries are
      sd-boot = config.boot.loader.systemd-boot;
      entries = "${
        if sd-boot.xbootldrMountPoint != null then
          sd-boot.xbootldrMountPoint
        else
          config.boot.loader.efi.efiSysMountPoint
      }/loader/entries";
      # the GUID the Boot Loader Interface reserves for systemd-boot's EFI variables: not
      # host-specific, it is compiled into systemd-boot and systemd
      loader-guid = "4a67b082-0a4c-41cf-b6c7-440b29bb8c4f";

      functions = ''
        # also kept in ${state}/events
        log_event() { echo "$(date '+%F %R') $*" | tee -a ${state}/events; }
        # the number of a generation that points at the given system
        generation_of() {
          for link in ${profile}-*-link; do
            if [ "$(readlink -f "$link")" = "$1" ]; then
              n=''${link#${profile}-}
              echo "''${n%-link}"
              return 0
            fi
          done
          return 1
        }
        default_generation() {
          n=$(readlink ${profile})
          n=''${n#system-}
          echo "''${n%-link}"
        }
        # makes generation $1 the default again and deletes generation $2: systemd-boot keeps the
        # entries of the last 2 generations, which must not include a failed one
        go_back() {
          nix-env --profile ${profile} --switch-generation "$1"
          nix-env --profile ${profile} --delete-generations "$2"
        }
      '';
    in
    {
      config = {
        # a new boot entry gets 3 attempts; one that never reaches boot-complete.target is skipped in
        # favour of the previous generation
        boot.loader.systemd-boot.bootCounting.enable = true;

        # each user sees new events once, at their next login (ssh or console)
        environment.loginShellInit = ''
          if [ -r ${state}/events ]; then
            _seen_file=''${XDG_STATE_HOME:-$HOME/.local/state}/auto-upgrade-seen
            _seen=$(cat "$_seen_file" 2>/dev/null || echo 0)
            _total=$(wc -l < ${state}/events)
            if [ "$_total" -gt "$_seen" ]; then
              echo "auto-upgrade:"
              tail -n "$((_total - _seen))" ${state}/events
              mkdir -p "''${_seen_file%/*}" && echo "$_total" > "$_seen_file"
            fi
            unset _seen_file _seen _total
          fi
        '';

        systemd.services = {
          nixos-upgrade = {
            # what to go back to
            preStart = "readlink -f /run/current-system > ${state}/running";
            onFailure = [ "auto-upgrade-rollback.service" ];
            serviceConfig.StateDirectory = "auto-upgrade";

            postStart = lib.mkMerge [
              # before the health check, while the reboot can still be called off
              (lib.mkBefore ''
                if grep -qxF "$(readlink -f ${profile})" ${state}/failed-boots 2>/dev/null; then
                  echo "this system already failed its boot checks: not deploying it again"
                  shutdown -c 2>/dev/null || true
                  exit 1
                fi
              '')
              # after a live health check that passed: the entry needs no check at its first boot, so
              # it is marked good the way systemd-bless-boot does, by dropping the counter from its name
              (lib.mkAfter ''
                running=$(readlink -f /run/current-system)
                grep -lF "init=$running/init" ${entries}/*+*.conf 2>/dev/null |
                  while read -r entry; do
                    mv "$entry" "''${entry%%+*}.conf" || echo "could not mark $entry good"
                  done
              '')
            ];
          };

          # same pattern as systemd-boot-check-no-failures.service: a new entry is only marked good once
          # the services are healthy
          health-check-boot = {
            description = "Health check before marking the boot entry good";
            after = [ "multi-user.target" ];
            before = [ "boot-complete.target" ];
            requiredBy = [ "boot-complete.target" ];
            onFailure = [ "health-check-boot-failed.service" ];
            # only at boot: a switch must not run it again
            restartIfChanged = false;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${lib.getExe config.core.health.package} 600";
            };
          };
          health-check-boot-failed = {
            description = "Reboot into the next boot attempt after a failed health check";
            # only while systemd-boot is counting attempts for this entry; after it fell back to a
            # previous generation, a failure must not start a reboot loop
            unitConfig.ConditionPathExists = "/sys/firmware/efi/efivars/LoaderBootCountPath-${loader-guid}";
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${config.systemd.package}/bin/systemctl reboot";
            };
          };

          # after systemd-boot fell back from the default entry, the profile still points at the
          # failed generation: it would stay the boot default, and the next upgrade would retry it
          auto-upgrade-fallback = {
            description = "Go back for good to the generation booted after a failed one";
            wantedBy = [ "multi-user.target" ];
            unitConfig.RequiresMountsFor = [ entries ];
            path = [ config.nix.package ];
            serviceConfig = {
              Type = "oneshot";
              StateDirectory = "auto-upgrade";
            };
            script = ''
              ${functions}
              booted=$(readlink -f /run/booted-system)
              default=$(readlink -f ${profile})
              if [ "$booted" = "$default" ]; then exit 0; fi
              # systemd-boot only skips the default entry once its counter ran out: nixos-...+0-<tries>.conf.
              # Anything else is a reboot still pending, or an entry picked by hand.
              case "$(grep -lF "init=$default/init" ${entries}/*.conf || true)" in
                *+0-*) ;;
                *) exit 0 ;;
              esac
              if ! good=$(generation_of "$booted"); then
                log_event "the default system failed its boot checks, and the booted one has no generation: left as is"
                exit 1
              fi
              failed=$(default_generation)

              # the next upgrades must not reboot into it again
              echo "$default" >> ${state}/failed-boots
              go_back "$good" "$failed"
              "$booted/bin/switch-to-configuration" boot
              log_event "generation $failed failed its boot checks and was deleted; generation $good runs (journalctl -b -1 -u health-check-boot)"
            '';
          };

          auto-upgrade-rollback = {
            description = "Go back to the system that ran before a failed upgrade";
            # it switches the system itself, so the switch must neither restart nor stop it
            restartIfChanged = false;
            unitConfig.X-StopOnRemoval = false;
            path = [ config.nix.package ];
            serviceConfig = {
              Type = "oneshot";
              StateDirectory = "auto-upgrade";
            };
            script = ''
              ${functions}
              running=$(cat ${state}/running 2>/dev/null || true)
              deployed=$(readlink -f ${profile})
              if [ "$deployed" = "$running" ]; then
                log_event "the upgrade failed; nothing was deployed (journalctl -u nixos-upgrade)"
                exit 0
              fi
              if ! good=$(generation_of "$running"); then
                log_event "the upgrade failed, and the previous system is unknown: not rolled back"
                exit 1
              fi
              failed=$(default_generation)

              echo "going back from generation $failed to $good"
              go_back "$good" "$failed"
              "$running/bin/switch-to-configuration" switch || echo "the switch back reported errors"

              result="rolled back to generation $good"
              if [ -x "$running/sw/bin/health-check" ] && ! "$running/sw/bin/health-check"; then
                result="$result, which is unhealthy too"
              fi
              log_event "the upgrade failed and was $result (journalctl -u nixos-upgrade -u auto-upgrade-rollback)"
            '';
          };
        };
      };
    };
}
