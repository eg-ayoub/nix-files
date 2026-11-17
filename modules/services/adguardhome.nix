{ ... }:
{
  flake.nixosModules.adguardhome =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.svc.adguardhome;
      ui-port = 3000;
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
        services.adguardhome = {
          enable = true;
          mutableSettings = true;
          settings = {
            dns = {
              bind_hosts = cfg.dns.hosts;
              port = cfg.dns.port;
            };
            http = {
              address = "127.0.0.1:${toString ui-port}";
            };
          };
        };
        svc.caddy.subdomains.adguardhome.extraConfig = ''
          reverse_proxy localhost:${toString ui-port}
        '';
        core.health.checks.adguardhome = {
          unit = "adguardhome.service";
          url = "https://adguardhome.${config.svc.caddy.domain}/";
          # any reply counts, SERVFAIL included: the resolver answers, whatever the upstreams do (its
          # upstream timeout is 10 s, hence +time=15)
          command = lib.concatMapStringsSep "\n" (
            host:
            "${pkgs.dnsutils}/bin/dig +time=15 +tries=1 -p ${toString cfg.dns.port} @${host} health-check.invalid > /dev/null"
          ) cfg.dns.hosts;
        };
      };
    };
}
