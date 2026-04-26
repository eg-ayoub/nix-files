{ ... }:
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
              # [
              #   "100.107.41.45"
              #   "fd7a:115c:a1e0::3b01:2985"
              # ];
              port = cfg.dns.port;
            };
          };
        };
      };
    };
}
