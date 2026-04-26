{ self, ... }:
{
  flake.nixosModules.yattee-server =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.svc.yattee-server;
    in
    {
      imports = [
        self.nixosModules.containers
      ];


      options.svc.yattee-server = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8085;
          description = "the port on which to serve yattee-server";
        };
      };

      config = {
        networking.firewall.allowedTCPPorts = [ cfg.port ];
        virtualisation.oci-containers.containers.yattee-server = {
          image = "yattee-server:latest";
          environment = {
            TZ = "Etc/CET";
          };
          ports = [
            "${toString cfg.port}:8085"
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
    };
}
