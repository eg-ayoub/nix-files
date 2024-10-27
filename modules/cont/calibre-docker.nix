{ pkgs, lib, config, ... }:
let
  cfg = config.cont.calibre;
in
{
  options.cont.calibre = {
    enable = lib.mkEnableOption "enable Calibre";
    listen = {
      port = lib.mkOption {
        default = 8080;
        description = "calibre desktop gui http";
        type = lib.types.port;
      };
      https_port = lib.mkOption {
        default = 8181;
        description = "calibre desktop gui https";
        type = lib.types.port;
      };
      webserver_port = lib.mkOption {
        default = 8081;
        description = "calibre webserve gui port";
        type = lib.types.port;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.calibre = {
      image = "lscr.io/linuxserver/calibre:latest";
      environment = {
        PUID=toString config.users.users.ayoub.uid;
        PGID=toString config.users.groups.users.gid;
        TZ="Etc/CET";
      };
      ports = [
        "${toString cfg.listen.port}:8080"
        "${toString cfg.listen.https_port}:8181"
        "${toString cfg.listen.webserver_port}:8081"
      ];
      volumes = [
        "/home/ayoub/cal:/config"
        "/mnt/drive:/drive"
      ];
      autoStart = false;
    };
  };
}
