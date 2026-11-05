{ self, ... }:
{
  flake.nixosModules.caddy =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.svc.caddy;
    in
    {

      imports = [
        self.nixosModules.sops
      ];

      options.svc.caddy = {
        hosts = lib.mkOption {
          type = lib.types.attrs;
          description = "the hosts that caddy will proxy and their configs";
        };
      };

      config = {
        sops.secrets."caddy.env" = {
          sopsFile = ../../secrets/caddy.env;
          format = "dotenv";
        };
        services.caddy = {
          enable = true;
          virtualHosts = cfg.hosts;
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
            hash = "sha256-3XnnBdOW8A+LmmcqR94v1ZkyMoMB3EfBWFv0uBzz4cA";
          };
          environmentFile = "/run/secrets/caddy.env";
          globalConfig = ''
            acme_dns porkbun {
              api_key {env.PORKBUN_API_KEY}
              api_secret_key {env.PORKBUN_API_SECRET_KEY}
            }
          '';
        };
      };
    };
}
