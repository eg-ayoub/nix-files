{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.jmp;
in
{
  options.apps.jmp = {
    enable = lib.mkEnableOption "enable Jellyfin Media Player";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jellyfin-media-player
    ];
  };
}
