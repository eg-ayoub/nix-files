{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.lutris;
in
{
  options.apps.lutris = {
    enable = lib.mkEnableOption "enable lutris";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
    ];
  };
}
