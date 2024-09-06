{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
  mywalls = (pkgs.callPackage ../../pkgs/mywalls.nix {}).mywalls;
in
{
  options.hyprland.utils = {};

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      hypridle
      hyprlock
      grimblast
      networkmanagerapplet
      xfce.ristretto
    ];

    services.swayosd.enable = true;

    programs.wpaperd = {
      enable = true;
      settings = {
        default = {
          path = "${mywalls.outPath}";
          duration = "10m";
        };
      };
    };
  };

}
