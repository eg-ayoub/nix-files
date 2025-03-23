{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.ipod;
in
{
  options.apps.ipod = {
    enable = lib.mkEnableOption "enable ipod tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rockbox-utility
      strawberry
    ];
  };
}
