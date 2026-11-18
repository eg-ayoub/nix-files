{ self, ... }:
{
  flake.nixosModules.auto-upgrade =
    { config, lib, ... }:
    {
      imports = [ self.nixosModules.health ];

      options.core.auto-upgrade.dates = lib.mkOption {
        type = lib.types.str;
        example = "03:30";
        description = ''
          when to upgrade, as a systemd OnCalendar value inside the 03:00 to 06:00 reboot window.
          Hosts that share a space get different times, so they don't build at once.
        '';
      };

      config = {
        system.autoUpgrade = {
          enable = true;
          # main on GitHub, fetched again on every run; its flake.lock moves weekly through the
          # update-inputs workflow
          flake = "github:eg-ayoub/nix-files#${config.networking.hostName}";
          # --upgrade updates channels, which a flake does not use
          upgrade = false;
          inherit (config.core.auto-upgrade) dates;
          # a new kernel, initrd or kernel modules is booted into rather than switched to. When that
          # falls outside the window (a missed night, caught up at boot), the run neither switches
          # nor reboots, and the next night's run reboots.
          allowReboot = true;
          rebootWindow = {
            lower = "03:00";
            upper = "06:00";
          };
        };

        # after every successful run, even one that changed nothing: an unhealthy system fails the
        # unit. A switch reloads systemd, which then runs the new generation's ExecStartPost, so the
        # checks are always those of the generation now running.
        systemd.services.nixos-upgrade.postStart = ''
          booted=$(readlink /run/booted-system/{initrd,kernel,kernel-modules})
          built=$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})
          if [ "$booted" != "$built" ]; then
            echo "health check skipped: the new generation only runs after the reboot"
            exit 0
          fi
          ${lib.getExe config.core.health.package}
        '';
      };
    };
}
