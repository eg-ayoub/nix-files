{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.spotify;
in
{
  options.apps.spotify = {
    enable = lib.mkEnableOption "enable spotify";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
