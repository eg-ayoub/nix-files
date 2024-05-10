{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  # options = {};

  config = lib.mkIf cfg.enable { 
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = [ "hyprland/language" "battery" "clock" "tray" ];
        "hyprland/window" = {
          icon = true;
          icon-size = 20;
          rewrite = {
            "(.{1,20}).* — Mozilla Firefox" = "$1…";
            "(.{1,20}).* - Google Chrome" = "$1…";
            "(.{1,20}).* - Slack" = "$1…";
          };
        };
      };
    };
  };

}
