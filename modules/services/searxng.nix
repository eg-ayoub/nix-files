{ self, ... }:
{
  flake.nixosModules.searxng =
    { config, ... }:
    {
      imports = [
        self.nixosModules.sops
      ];

      config = {
        sops.secrets."searxng.env" = {
          sopsFile = ../../secrets/searxng.env;
          format = "dotenv";
          restartUnits = [ "searx.service" ];
        };
        services.searx = {
          enable = true;
          redisCreateLocally = true;
          settings = {
            server = {
              bind_address = "127.0.0.1";
              port = 8888;
            };
            search = {
              formats = [
                "html"
                "json"
              ];
            };
          };
          environmentFile = config.sops.secrets."searxng.env".path;
        };
        svc.caddy.subdomains.search.extraConfig = ''
          reverse_proxy localhost:${toString config.services.searx.settings.server.port}
        '';
      };
    };
}
