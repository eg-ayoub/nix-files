{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.ipod;
  clementine-pkg = pkgs.clementine.override {
    config.clementine.ipod = true;
  };
in
{
  options.apps.ipod = {
    enable = lib.mkEnableOption "enable ipod tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rockbox-utility
      strawberry
      clementine-pkg
    ];
  };
}
