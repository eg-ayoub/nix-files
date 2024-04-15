{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.chrome;
in
{
  options.apps.chrome = {
    enable = lib.mkEnableOption "enable chrome";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
