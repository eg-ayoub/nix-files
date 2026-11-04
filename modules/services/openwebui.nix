{ ... }:
{
  flake.nixosModules.openwebui =
    { lib, config, ... }:
    let
      cfg = config.svc.openwebui;
    in
    {
      options.svc.openwebui = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "host on which to serve open-webui";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 9120;
          description = "port on which to serve open-webui";
        };
      };

      config = {
        services.open-webui = {
          enable = true;
          host = cfg.host;
          port = cfg.port;
          openFirewall = true;
        };

      };
    };
}
