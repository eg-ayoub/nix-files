{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  options.hyprland.utils = {};

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      hyprpaper
      hypridle
      hyprlock
      grimblast
      networkmanagerapplet
      xfce.ristretto
    ];

    services.swayosd.enable = true;
  };

}
