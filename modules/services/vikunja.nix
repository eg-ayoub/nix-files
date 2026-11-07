{ ... }:
{
  flake.nixosModules.vikunja =
    { ... }:
    {
      config = {
        sops.secrets."vikunja.env" = {
          sopsFile = ../../secrets/vikunja.env;
          format = "dotenv";
        };
        services.vikunja = {
          enable = true;
          address = "127.0.0.1";
          frontendScheme = "https";
          frontendHostname = "reminders.poire.me";
          port = 3456;
          environmentFiles = [ "/run/secrets/vikunja.env" ];
          settings = {
            service = {
              # Whether to let new user register themselves.
              enableregistration = true;
              # The maximum size clients will be able to request for user avatars.
              # If clients request a size bigger than this, it will be changed on the fly.
              maxavatarsize = 4096;
              # The duration of the issued JWT tokens in seconds.
              jwtttl = 2592000;
              # The duration of the "remember me" time in seconds. When the login request is
              # made with the long param set, the token returned will be valid for this period.
              jwtttllong = 25920000;
              maxitemsperpage = 100;
            };
          };
        };
        svc.caddy.hosts."reminders.poire.me".extraConfig = ''
          reverse_proxy localhost:3456
        '';
      };
    };
}
