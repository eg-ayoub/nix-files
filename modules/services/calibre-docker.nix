{ self, ... }:
{
  flake.nixosModules.calibre-docker =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.services.calibre-docker;
    in
    {
      imports = [
        self.nixosModules.containers
      ];

      options.services.calibre-docker = {
        webserve-port = lib.mkOption {
          type = lib.types.port;
          default = 8083;
          description = "port on which ot serve calibre webserve gui";
        };
        https-port = lib.mkOption {
          type = lib.types.port;
          default = 8181;
          description = "https port on which to serve calibre https gui";
        };
      };

      config = {
        virtualisation.oci-containers.containers.calibre = {
          image = "quay.io/linuxserver.io/calibre:latest";
          environment = {
            PUID = toString config.users.users.ayoub.uid;
            PGID = toString config.users.groups.users.gid;
            TZ = "Etc/CET";
          };
          ports = [
            "${toString cfg.https-port}:8181"
            "${toString cfg.webserver-port}:8081"
          ];
          volumes = [
            "/home/ayoub/cal:/config"
            "/mnt/drive:/drive"
          ];
          autoStart = false;
        };
      };
    };
}
