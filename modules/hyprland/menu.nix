{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  options.hyprland.menu = {};

  config = lib.mkIf cfg.enable {
    programs.fuzzel.enable = true;
  };

}
