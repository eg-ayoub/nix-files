{ ... }:
{
  flake.nixosModules.n8n =
    { lib, config, ... }:
    let
      cfg = config.svc.n8n;
    in
    {
      options.svc.n8n = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 5678;
          description = "port on which to serve n8n";
        };
      };

      config = {
        services.n8n = {
          enable = true;
          openFirewall = true;
          environment = {
            N8N_PORT = cfg.port;
          };
        };

      };
    };
}
