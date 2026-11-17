{ self, ... }:
{
  flake.nixosModules.auto-update =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.core.auto-update;
      host = config.networking.hostName;
      repo = "/var/lib/auto-update/repo";

      auto-update = pkgs.writeShellApplication {
        name = "auto-update";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.gitMinimal
          pkgs.openssh
          config.nix.package
          config.systemd.package
          config.system.build.nixos-rebuild
          self.packages.${pkgs.stdenv.hostPlatform.system}.update-images
        ];
        text = ''
          repo=${repo}
          profile=/nix/var/nix/profiles/system

          # the health checks of whichever system is running: the new one, or the old one after a
          # rollback
          health() {
            if [ -x /run/current-system/sw/bin/health-check ]; then
              /run/current-system/sw/bin/health-check
            fi
          }

          # 1. the repository's main branch
          if [ ! -d "$repo/.git" ]; then
            git clone --quiet https://github.com/eg-ayoub/nix-files.git "$repo"
          fi
          git -C "$repo" fetch --quiet origin main
          git -C "$repo" checkout --quiet --force -B main origin/main
          git -C "$repo" clean -fdq

          # 2. lulu, once a week: update the lock and the image digests, and commit if every host
          # still evaluates
          ${lib.optionalString cfg.update-lock ''
            lock_commit=
            if [ "$(date +%u)" = ${toString cfg.lock-weekday} ]; then
              if (cd "$repo" && nix flake update && update-images && nix flake check --no-build); then
                if ! git -C "$repo" diff --quiet; then
                  git -C "$repo" -c user.name=${host} -c user.email=auto-update@${host} \
                    commit --quiet --all --message "chore(flake): update inputs"
                  lock_commit=$(git -C "$repo" rev-parse HEAD)
                  echo "lock updated: $lock_commit"
                fi
              else
                echo "the lock update failed its checks; deploying main unchanged"
                git -C "$repo" reset --quiet --hard origin/main
                git -C "$repo" clean -fdq
              fi
            fi
          ''}

          # 3. switch, keeping what is needed to come back
          prev_system=$(readlink -f /run/current-system)
          prev_generation=$(readlink "$profile")
          status=0
          nixos-rebuild switch --flake "$repo#${host}" || status=$?
          new_system=$(readlink -f /run/current-system)
          new_generation=$(readlink "$profile")

          rollback() {
            echo "rolling back to $prev_system"
            if [ "$new_generation" != "$prev_generation" ]; then
              number=''${prev_generation#system-}
              nix-env --profile "$profile" --switch-generation "''${number%-link}" ||
                echo "could not point the profile back at $prev_generation"
            fi
            "$prev_system/bin/switch-to-configuration" switch || true
            if health; then
              echo "healthy again after the rollback"
            else
              echo "still unhealthy after the rollback"
            fi
            exit 1
          }

          if [ "$new_system" = "$prev_system" ] && [ "$new_generation" = "$prev_generation" ]; then
            if [ "$status" -ne 0 ]; then
              echo "the build failed; the running system is unchanged"
              exit 1
            fi
            echo "already up to date"
          elif [ "$status" -ne 0 ]; then
            echo "the switch failed"
            rollback
          fi

          # 4. a system that does not pass its checks is rolled back; one that was already running
          # is only reported
          if ! health; then
            if [ "$new_system" != "$prev_system" ]; then
              rollback
            fi
            echo "unhealthy, with no update to roll back"
            exit 1
          fi

          ${lib.optionalString cfg.update-lock ''
            # 5. publish the lock this host is now healthy on, for the other hosts to deploy
            if [ -n "$lock_commit" ]; then
              if GIT_SSH_COMMAND="ssh -i ${config.sops.secrets.deploy-key.path} -o IdentitiesOnly=yes" \
                git -C "$repo" push --quiet git@github.com:eg-ayoub/nix-files.git "$lock_commit:refs/heads/main"; then
                echo "pushed $lock_commit to main"
              else
                echo "the push was rejected (main moved?); the lock update is retried next week"
              fi
            fi
          ''}

          # 6. a new kernel, initrd or kernel modules only take effect after a reboot; boot counting
          # and health-check-boot guard it
          booted=$(readlink /run/booted-system/{initrd,kernel,kernel-modules})
          built=$(readlink /run/current-system/{initrd,kernel,kernel-modules})
          if [ "$booted" != "$built" ]; then
            echo "the kernel changed: rebooting"
            systemctl reboot
          fi
        '';
      };
    in
    {
      imports = [
        self.nixosModules.health
        self.nixosModules.sops
      ];

      options.core.auto-update = {
        dates = lib.mkOption {
          type = lib.types.str;
          description = "when to update, as a systemd OnCalendar value";
        };
        update-lock = lib.mkEnableOption "the weekly flake.lock and image digest update, pushed to main once this host is healthy on it";
        lock-weekday = lib.mkOption {
          type = lib.types.ints.between 1 7;
          default = 6;
          description = "day of the lock update, 1 for Monday";
        };
      };

      config = lib.mkMerge [
        {
          systemd = {
            services.auto-update = {
              description = "Update to the repository's main branch, and roll back if it breaks";
              # the switch must not stop or restart the unit running it
              restartIfChanged = false;
              unitConfig.X-StopOnRemoval = false;
              after = [ "network-online.target" ];
              wants = [ "network-online.target" ];
              environment = config.nix.envVars // {
                HOME = "/root";
              };
              serviceConfig = {
                Type = "oneshot";
                ExecStart = lib.getExe auto-update;
                StateDirectory = "auto-update";
              };
            };
            timers.auto-update = {
              wantedBy = [ "timers.target" ];
              timerConfig = {
                OnCalendar = cfg.dates;
                Persistent = true;
                RandomizedDelaySec = "5min";
              };
            };
            # never collect garbage in the middle of an update
            services.nix-gc.after = [ "auto-update.service" ];
          };
        }

        (lib.mkIf cfg.update-lock {
          # a GitHub deploy key with write access to the repository
          sops.secrets.deploy-key = {
            sopsFile = ../../../secrets/deploy-key.yaml;
            key = "flake_update_key";
          };
          programs.ssh.knownHosts."github.com".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        })
      ];
    };
}
