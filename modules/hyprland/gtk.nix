{ pkgs, lib, config, ... }:
let
  cfg = config.hyprland.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = { 
        name = "Tokyonight-Dark-B";
        package = pkgs.tokyonight-gtk-theme;
      };
      iconTheme = {
        name = "Qogir";
        package = pkgs.qogir-icon-theme;
      };
      cursorTheme = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        size = 24;
      };
    };
  };
}
