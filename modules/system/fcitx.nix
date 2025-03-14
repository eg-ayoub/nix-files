{ lib, config, pkgs, ... }:

let
  cfg = config.system.fcitx;
in
{

  options.system.fcitx = {
    enable = lib.mkEnableOption "enable fcitx";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-configtool
      ];
    };

    # Would normally set this to fcitx, but kitty only supports ibus, and fcitx
    # provides an ibus interface. Can't use ibus for e.g. QT_IM_MODULE though,
    # because that at least breaks mumble
    environment.variables.GLFW_IM_MODULE = "ibus";
  };
}
