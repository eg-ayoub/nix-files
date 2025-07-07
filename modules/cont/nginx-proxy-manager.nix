{ pkgs, lib, config, ... }:
let
  cfg = config.cont.nginx-proxy-manager;
in
{
  options.cont.nginx-proxy-manager = {
    enable = lib.mkEnableOption "enable Nginx Proxy Manager";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 81 443 ];
    systemd.services.create-nginx-proxy-manager-volumes = {
      description = "Create state folders for NPM";
      serviceConfig = {
        Type = "oneshot";
        RemainsAfterExit = true;
      };
      script = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/NginxProxyManager/data
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/NginxProxyManager/letsencrypt
      '';
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
    };
    virtualisation.oci-containers.containers.nginx-proxy-manager = {
      image = "jc21/nginx-proxy-manager:latest";
      environment = {
        TZ="Etc/CET";
      };
      ports = [
        "80:80"
        "443:443"
        "81:81"
      ];
      volumes = [
        "/var/lib/NginxProxyManager/data:/data"
        "/var/lib/NginxProxyManager/letsencrypt:/etc/letsencrypt"
      ];
      autoStart = true;
    };
    systemd.services.nginx-proxy-manager = {
      after = [
        "network-online.service"
        "systemd-networkd.service"
        "create-nginx-proxy-manager-volumes.service"
      ];
      serviceConfig = {
        StateDirectory = "NginxProxyManager";
      };
    };
  };
}
