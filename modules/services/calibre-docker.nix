{ self, ... }:
{
  flake.nixosModules.calibre-docker =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.svc.calibre-docker;
    in
    {
      imports = [
        self.nixosModules.containers
        self.nixosModules.sops
      ];

      options.svc.calibre-docker = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8180;
          description = "localhost port on which to serve the calibre desktop gui to caddy";
        };
      };

      config = {
        # CUSTOM_USER and PASSWORD turn on the gui's HTTP basic auth. No restartUnits: a rebuild
        # would start the stopped container (stopping calibre-web); it reads them at each start.
        sops.secrets."calibre.env" = {
          sopsFile = ../../secrets/calibre.env;
          format = "dotenv";
        };
        virtualisation.oci-containers.containers.calibre = {
          # pinned by digest (container-images.json, refreshed by update-images), so a rollback
          # restores the previous image too
          image = with (lib.importJSON ./container-images.json).calibre; "${repo}@${digest}";
          environment = {
            PUID = toString config.users.users.ayoub.uid;
            PGID = toString config.users.groups.users.gid;
            TZ = config.time.timeZone;
          };
          # 8080 is the image's plain-http gui, meant to sit behind a reverse proxy
          ports = [
            "127.0.0.1:${toString cfg.port}:8080"
          ];
          volumes = [
            "${config.users.users.ayoub.home}/cal:/config"
            "/mnt/drive/Books:/drive/Books"
          ];
          environmentFiles = [ config.sops.secrets."calibre.env".path ];
          autoStart = false;
        };
        systemd.services.podman-calibre = {
          # both write the same calibre library, so never run them at the same time
          conflicts = [ "calibre-web.service" ];
          unitConfig.RequiresMountsFor = [ "/mnt/drive/Books" ];
        };
        svc.caddy.subdomains.calibre-desktop.extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
      };
    };
}
