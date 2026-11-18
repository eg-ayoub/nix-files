{ ... }:
{
  # imported by auto-upgrade, which also brings the health module
  flake.nixosModules.rollback =
    { config, ... }:
    let
      state = "/var/lib/auto-upgrade";
      profile = "/nix/var/nix/profiles/system";

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
      config.systemd.services = {
        nixos-upgrade = {
          # what to go back to
          preStart = "readlink -f /run/current-system > ${state}/running";
          onFailure = [ "auto-upgrade-rollback.service" ];
          serviceConfig.StateDirectory = "auto-upgrade";
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
}
