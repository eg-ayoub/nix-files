{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  # options = {};

  config = lib.mkIf cfg.enable { 
    services.cliphist = {
      enable = true;
    };
  };

}
