{ ... }:
{
  flake.nixosModules.invidious =
    { lib, config, ... }:
    let
      cfg = config.services.invidious;
    in
    {

      options.services.invidious = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8090;
          descritption = "the port on which to serve invidious";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          descritption = "domain name so invidious can craft absolute URLs";
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
