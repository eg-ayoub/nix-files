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
        modules-right = [ "hyprland/language" "battery" "pulseaudio" "clock" "tray" ];
        "hyprland/window" = {
          icon = true;
          icon-size = 20;
          rewrite = {
            "(.{1,20}).* — Mozilla Firefox" = "$1…";
            "(.{1,20}).* - Google Chrome" = "$1…";
            "(.{1,20}).* - Slack" = "$1…";
          };
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 10;
          };
          "format" = "{capacity}% {icon}";
          "format-icons" = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹" ];
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon}";
          "format-icons" = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "󰽟";
            "alsa_output.usb-Native_Instruments_Komplete_Audio_1_000046E0-00.analog-stereo" = "󰾲 󰋋";
            "alsa_output.pci-0000_00_1f.3.hdmi-stereo" = "";
            "default" = [ "" "" ];
          };
          "on-click" = "pavucontrol";
        };
      };
    };
  };

}
