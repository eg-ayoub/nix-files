{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  options.hyprland.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
    monitors = lib.mkOption {
      default = [];
      description = "Monitors setup for hyprland";
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    systemd = {
      user.services.polkit-kde-authentication-agent-1 = {
        Unit = {
          Description = "polkit-kde-authentication-agent-1";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
      # too big
      settings = let 
        monitors = cfg.monitors; 
      in 
        import ./config.nix { inherit monitors; } ;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
    };
  };

}
