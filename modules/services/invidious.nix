{ ... }:
{
  flake.nixosModules.invidious =
    { lib, config, ... }:
    let
      cfg = config.svc.invidious;
    in
    {

      options.svc.invidious = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8090;
          description = "the port on which to serve invidious";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          description = "domain name so invidious can craft absolute URLs";
        };
      };

      config = {
        networking.firewall.allowedTCPPorts = [ cfg.port ];
        services.invidious = {
          enable = true;
          domain = cfg.domain;
          port = cfg.port;
          settings = {
            external_port = cfg.port;
            db = {
              user = "invidious";
              dbname = "invidious";
            };
          };
          extraSettingsFile = "/mnt/drive/invidious/config.json";
        };
      };
    };
}
