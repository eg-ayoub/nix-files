{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  options.hyprland.notif = {};

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      swaynotificationcenter
    ];
  };

}
