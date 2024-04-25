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
      # too big
      settings = import ./config.nix;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
    };
    programs.wofi.enable = true;
  };

}
