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
      ];

      options.svc.calibre-docker = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8180;
          description = "localhost port on which to serve the calibre desktop gui to caddy";
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
          # 8080 is the image's plain-http gui, meant to sit behind a reverse proxy
          ports = [
            "127.0.0.1:${toString cfg.port}:8080"
          ];
          volumes = [
            "/home/ayoub/cal:/config"
            "/mnt/drive/Books:/drive/Books"
          ];
          autoStart = false;
        };
        systemd.services.podman-calibre = {
          # both write the same calibre library, so never run them at the same time
          conflicts = [ "calibre-web.service" ];
          unitConfig.RequiresMountsFor = [ "/mnt/drive/Books" ];
        };
        svc.caddy.hosts."calibre-desktop.poire.me".extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
      };
    };
}
