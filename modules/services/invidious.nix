{ self, ... }:
{
  flake.nixosModules.invidious =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.svc.invidious;
      inv = config.services.invidious;
      key = config.sops.placeholder.invidious-companion-key;
    in
    {
      imports = [
        self.nixosModules.containers
        self.nixosModules.sops
      ];

      options.svc.invidious = {
        companion-port = lib.mkOption {
          type = lib.types.port;
          default = 8282;
          description = "localhost port on which to serve invidious-companion";
        };
      };

      config = {
        services.invidious = {
          enable = true;
          address = "127.0.0.1";
          domain = "invidious.${config.svc.caddy.domain}";
          port = 8090;
          settings = {
            external_port = 443;
            https_only = true;
            db = {
              user = "invidious";
              dbname = "invidious";
            };
            invidious_companion = [
              {
                private_url = "http://localhost:${toString cfg.companion-port}/companion";
                public_url = "https://${inv.domain}/companion";
              }
            ];
          };
          extraSettingsFile = "/run/credentials/invidious.service/companion-key.json";
        };
        # invidious runs as a dynamic user, so the root-only file reaches it as a systemd credential
        systemd.services.invidious.serviceConfig.LoadCredential = [
          "companion-key.json:${config.sops.templates."invidious-companion.json".path}"
        ];

        # one secret, rendered for both sides so they cannot drift apart
        sops = {
          secrets.invidious-companion-key = {
            sopsFile = ../../secrets/invidious.yaml;
            key = "companion_key";
          };
          templates."invidious-companion.env" = {
            content = ''
              SERVER_SECRET_KEY=${key}
            '';
            restartUnits = [ "podman-invidious-companion.service" ];
          };
          templates."invidious-companion.json" = {
            content = builtins.toJSON { invidious_companion_key = key; };
            restartUnits = [ "invidious.service" ];
          };
        };

        virtualisation.oci-containers.containers.invidious-companion = {
          # pinned by digest (container-images.json, refreshed by update-images), so a rollback
          # restores the previous image too
          image = with (lib.importJSON ./container-images.json).invidious-companion; "${repo}@${digest}";
          ports = [
            "127.0.0.1:${toString cfg.companion-port}:8282"
          ];
          volumes = [
            "/mnt/drive/invidious-companion/companioncache:/var/tmp/youtubei.js:rw"
          ];
          environmentFiles = [
            config.sops.templates."invidious-companion.env".path
          ];
          autoStart = true;
        };
        systemd.services.podman-invidious-companion.unitConfig.RequiresMountsFor = [
          "/mnt/drive/invidious-companion"
        ];

        # with public_url set, video streams go from caddy straight to the companion, not through invidious
        svc.caddy.subdomains.invidious.extraConfig = ''
          reverse_proxy /companion/* localhost:${toString cfg.companion-port}
          reverse_proxy localhost:${toString inv.port}
        '';

        core.users.ayoub.extra-sudo-commands = [
          "/run/current-system/sw/bin/systemctl restart invidious.service"
          "/run/current-system/sw/bin/systemctl restart podman-invidious-companion.service"
        ];
      };
    };
}
