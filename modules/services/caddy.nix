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
      site = lib.types.submodule {
        options.extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Caddyfile directives for this site";
        };
      };
    in
    {

      imports = [
        self.nixosModules.sops
      ];

      options.svc.caddy = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = "poire.me";
          description = "domain under which services are published as subdomains";
        };
        subdomains = lib.mkOption {
          type = lib.types.attrsOf site;
          default = { };
          description = "sites served as <name>.<domain>";
        };
        hosts = lib.mkOption {
          type = lib.types.attrsOf site;
          default = { };
          description = "sites served under a full address, for those that are not a subdomain";
        };
      };

      config = {
        core.health.checks.caddy.unit = "caddy.service";
        sops.secrets."caddy.env" = {
          sopsFile = ../../secrets/caddy.env;
          format = "dotenv";
          restartUnits = [ "caddy.service" ];
        };
        services.caddy = {
          enable = true;
          virtualHosts = lib.mkMerge [
            (lib.mapAttrs' (
              name: site: lib.nameValuePair "${name}.${cfg.domain}" { inherit (site) extraConfig; }
            ) cfg.subdomains)
            (lib.mapAttrs (_: site: { inherit (site) extraConfig; }) cfg.hosts)
          ];
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
            hash = "sha256-8DrezGjdIUq9tBvbK7UuVDeQPuzUdBsmIkI79YDCTOQ";
          };
          environmentFile = config.sops.secrets."caddy.env".path;
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
