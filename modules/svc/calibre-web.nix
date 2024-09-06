{ pkgs, lib, config, ... }:
let
  cfg = config.svc.calibre-web;
in
{
  options.svc.calibre-web = {
    enable = lib.mkEnableOption "enable Calibre Web";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.calibre-web
    ];
    services.calibre-web = {
      enable = true;
      listen.ip = "192.168.1.45";
      openFirewall = true;
      user="ayoub";
      group="users";
      options = {
        # calibreLibrary = /mnt/drive/calibre-web;
        enableBookConversion = true;
        enableKepubify = true;
        enableBookUploading = true;
      };
    };
  };
}
