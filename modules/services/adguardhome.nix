{ self, ... }:
{
  flake.nixosModules.adguardhome =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.svc.adguardhome;
    in
    {

      imports = [
        self.nixosModules.caddy
      ];

      options.svc.adguardhome.dns = {
        hosts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "the hosts on which to serve dns";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 53;
          description = "the port on which to serve dns";
        };
      };

      config = {
        environment.systemPackages = [
          pkgs.adguardhome
        ];
        services.adguardhome = {
          enable = true;
          mutableSettings = true;
          openFirewall = true;
          settings = {
            dns = {
              bind_hosts = cfg.dns.hosts;
              port = cfg.dns.port;
            };
            http = {
              address = "127.0.0.1:3000";
            };
          };
        };
        svc.caddy.hosts."adguardhome.poire.me".extraConfig = ''
          reverse_proxy localhost:3000
        '';
      };
    };
}
