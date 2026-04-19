{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.cont.yattee-server;
in
{
  options.cont.yattee-server = {
    enable = lib.mkEnableOption "enable Yattee-server";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8085 ];
    virtualisation.oci-containers.containers.yattee-server = {
      image = "yattee-server:latest";
      environment = {
        TZ = "Etc/CET";
      };
      ports = [
        "8085:8085"
      ];
      volumes = [
        "/mnt/drive/yattee/downloads:/downloads"
        "/mnt/drive/yattee/data:/app/data"
      ];
      environmentFiles = [
        "/mnt/drive/yattee/.env"
      ];
      autoStart = true;
    };
  };
}
