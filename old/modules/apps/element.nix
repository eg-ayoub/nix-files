{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

let
  cfg = config.apps.element;
in
{
  options.apps.element = {
    enable = lib.mkEnableOption "enable element desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      element-desktop
    ];
  };
}
