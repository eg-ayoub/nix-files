{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  options.hyprland.menu = {};

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = "Inconsolata Nerd Font 12";
      pass = {
        enable = true;
        package = pkgs.rofi-pass-wayland;
      };
      theme = "Arc-Dark";
    };
  };

}
