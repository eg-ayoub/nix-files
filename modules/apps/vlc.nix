{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.vlc;
in
{
  options.apps.vlc = {
    enable = lib.mkEnableOption "enable VLC Media Player";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
