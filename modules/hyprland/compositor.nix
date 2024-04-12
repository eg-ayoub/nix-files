{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;
in
{
  options.hyprland.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
      extraConfig =  lib.fileContents ./hyprland.conf;
    };
  };

}
