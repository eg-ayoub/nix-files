{ ... }:
{
  flake.nixosModules.invidious =
    {
      ...
    }:
    {

      config = {
        services.invidious = {
          enable = true;
          address = "127.0.0.1";
          domain = "invidious.poire.me";
          port = 8090;
          settings = {
            external_port = 443;
            https_only = true;
            db = {
              user = "invidious";
              dbname = "invidious";
            };
          };
        };
        core.users.ayoub.extra-sudo-commands = [
          "/run/current-system/sw/bin/systemctl restart invidious.service"
        ];
        svc.caddy.hosts."invidious.poire.me".extraConfig = ''
          reverse_proxy localhost:8090
        '';
      };
    };
}
