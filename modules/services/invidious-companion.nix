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
      key = config.sops.placeholder.invidious-companion-key;
    in
    {
      imports = [
        self.nixosModules.containers
        self.nixosModules.sops
      ];

      options.svc.invidious-companion = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8282;
          description = "the port on which to serve invidious-companion";
        };
      };

      config = {
        # one secret, rendered for both sides so they cannot drift apart
        sops.secrets.invidious-companion-key = {
          sopsFile = ../../secrets/invidious.yaml;
          key = "companion_key";
        };
        sops.templates."invidious-companion.env" = {
          content = ''
            SERVER_SECRET_KEY=${key}
          '';
          restartUnits = [ "podman-invidious-companion.service" ];
        };
        sops.templates."invidious-companion.json" = {
          content = builtins.toJSON { invidious_companion_key = key; };
          restartUnits = [ "invidious.service" ];
        };

        virtualisation.oci-containers.containers.invidious-companion = {
          image = "quay.io/invidious/invidious-companion:latest";
          ports = [
            "127.0.0.1:${toString cfg.port}:8282"
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

        services.invidious = {
          settings.invidious_companion = [
            {
              private_url = "http://localhost:${toString cfg.port}/companion";
              public_url = "https://${config.services.invidious.domain}/companion";
            }
          ];
          extraSettingsFile = "/run/credentials/invidious.service/companion-key.json";
        };
        # invidious runs as a dynamic user, so the root-only file reaches it as a systemd credential
        systemd.services.invidious.serviceConfig.LoadCredential = [
          "companion-key.json:${config.sops.templates."invidious-companion.json".path}"
        ];

        # with public_url set, video streams go from caddy straight to the companion, not through invidious
        services.caddy.virtualHosts.${config.services.invidious.domain}.extraConfig = ''
          reverse_proxy /companion/* localhost:${toString cfg.port}
        '';

        core.users.ayoub.extra-sudo-commands = [
          "/run/current-system/sw/bin/systemctl restart podman-invidious-companion.service"
        ];
      };
    };
}
