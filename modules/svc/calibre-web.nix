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
    listen = {
      port = lib.mkOption {
        default = 8083;
        description = "Calibre Web HTTP port";
        type = lib.types.port;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # only listen through NPM
    networking.firewall.interfaces.podman0.allowedTCPPorts = [ cfg.listen.port ];
    environment.systemPackages = [
      calibre-package
    ];
    services.calibre-web = {
      package = calibre-package;
      enable = true;
      listen.ip = "0.0.0.0";
      listen.port = cfg.listen.port;
      # openFirewall = true;
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
