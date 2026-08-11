{ ... }:
{
  flake.nixosModules.searxng =
    { config, lib, ... }:
    let
      cfg = config.svc.searxng;
    in
    {
      options.svc.searxng = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "address to bind searxng to";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 8888;
          description = "port on which to serve searxng";
        };
      };

      config = {
        services.searx = {
          enable = true;
          redisCreateLocally = true;
          settings = {
            server = {
              bind_address = cfg.host;
              port = cfg.port;
            };
            search = {
              formats = [
                "html"
                "json"
              ];
            };
          };
          environmentFile = "/mnt/drive/searxng/.env";
          openFirewall = true;
        };
      };
    };
}
