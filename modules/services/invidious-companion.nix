{ self, ... }:
{
  flake.nixosModules.invidious-companion =
    { lib, config, ... }:
    let
      cfg = config.svc.invidious-companion;
    in
    {
      imports = [
        self.nixosModules.containers
      ];

      options.svc.invidious-companion = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8282;
          description = "the port on which to serve invidious-companion";
        };
      };

      config = {
        networking.firewall.allowedTCPPorts = [ cfg.port ];

        virtualisation.oci-containers.containers.invidious-companion = {
          image = "quay.io/invidious/invidious-companion:latest";
          ports = [
            "${toString cfg.port}:8282"
          ];
          volumes = [
            "/mnt/drive/invidious-companion/companioncache:/var/tmp/youtubei.js:rw"
          ];
          environmentFiles = [
            "/mnt/drive/invidious-companion/.env"
          ];
          autoStart = true;
        };
      };
    };
}
