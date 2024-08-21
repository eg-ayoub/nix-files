{ pkgs, lib, config, ... }:
let
  cfg = config.svc.jellyfin;
in
{
  options.svc.jellyfin = {
    enable = lib.mkEnableOption "enable Jellyfin";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      user="ayoub";
    };
  };
}
