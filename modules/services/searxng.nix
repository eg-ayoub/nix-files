{ ... }:
{
  flake.nixosModules.searxng =
    { ... }:
    {

      config = {
        sops.secrets."searxng.env" = {
          sopsFile = ../../secrets/searxng.env;
          format = "dotenv";
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
          environmentFile = "/run/secrets/searxng.env";
        };
        svc.caddy.hosts."search.poire.me".extraConfig = ''
          reverse_proxy localhost:8888
        '';
      };
    };
}
