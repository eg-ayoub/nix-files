{ pkgs, lib, config, ... }:
let
  cfg = config.svc.calibre-web;
  calibre-package = pkgs.calibre-web.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ [ pkgs.calibre-web.optional-dependencies.kobo];
  });
in
{
  options.svc.calibre-web = {
    enable = lib.mkEnableOption "enable Calibre Web";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      calibre-package
    ];
    services.calibre-web = {
      package = calibre-package;
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
