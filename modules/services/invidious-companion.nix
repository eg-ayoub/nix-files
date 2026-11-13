{ self, ... }:
{
  flake.nixosModules.invidious-companion =
    {
      lib,
      config,
      ...
    }:
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
        virtualisation.oci-containers.containers.invidious-companion = {
          image = "quay.io/invidious/invidious-companion:latest";
          ports = [
            "127.0.0.1:${toString cfg.port}:8282"
          ];
          volumes = [
            "/mnt/drive/invidious-companion/companioncache:/var/tmp/youtubei.js:rw"
          ];
          environmentFiles = [
            "/mnt/drive/invidious-companion/.env"
          ];
          autoStart = true;
        };
        systemd.services.podman-invidious-companion.unitConfig.RequiresMountsFor = [
          "/mnt/drive/invidious-companion"
        ];
        core.users.ayoub.extra-sudo-commands = [
          "/run/current-system/sw/bin/systemctl restart podman-invidious-companion.service"
        ];
      };
    };
}
