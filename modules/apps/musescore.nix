{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.musescore;
in
{
  options.apps.musescore = {
    enable = lib.mkEnableOption "enable musescore";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      musescore
    ];
  };
}
