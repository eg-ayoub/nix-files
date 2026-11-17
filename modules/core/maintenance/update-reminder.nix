{ ... }:
{
  flake.nixosModules.update-reminder =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      host = config.networking.hostName;

      update-reminder = pkgs.writeShellApplication {
        name = "update-reminder";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.gitMinimal
          pkgs.libnotify
        ];
        text = ''
          # nags once the running system is a week old and main has moved on
          running=$(/run/current-system/sw/bin/nixos-version --configuration-revision || true)
          main=$(git ls-remote https://github.com/eg-ayoub/nix-files.git refs/heads/main | cut -f1 || true)
          if [ -z "$main" ] || [ "$running" = "$main" ]; then
            exit 0
          fi

          # store paths all date from 1970; the generation link is created by the switch
          generation=/nix/var/nix/profiles/$(readlink /nix/var/nix/profiles/system)
          age_days=$(( ($(date +%s) - $(stat -c %Y "$generation")) / 86400 ))
          if [ "$age_days" -ge 7 ]; then
            notify-send --app-name=NixOS "${host} is $age_days days behind" \
              "To update: sudo nixos-rebuild switch --flake github:eg-ayoub/nix-files#${host}"
          fi
        '';
      };
    in
    {
      config = {
        systemd.user.services.update-reminder = {
          description = "Remind to update once this system falls behind main";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = lib.getExe update-reminder;
          };
        };
        systemd.user.timers.update-reminder = {
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          timerConfig = {
            OnActiveSec = "10min";
            OnUnitActiveSec = "1d";
          };
        };
      };
    };
}
