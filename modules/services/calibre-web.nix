{ ... }:
{
  flake.nixosModules.calibre-web =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.svc.calibre-web;
      calibre-pkg = pkgs.calibre-web.overridePythonAttrs (oldAttrs: {
        dependencies = oldAttrs.dependencies ++ pkgs.calibre-web.optional-dependencies.kobo;
      });
    in
    {
      options.svc.calibre-web = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 8083;
          description = "localhost port on which to serve calibre-web to caddy";
        };
        kobo-lan = {
          interface = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "LAN interface on which to expose the Kobo sync endpoints, for e-readers that cannot join the tailnet";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 8084;
            description = "plain-http port on which to expose the Kobo sync endpoints";
          };
        };
      };

      config = lib.mkMerge [
        {
          environment.systemPackages = [
            calibre-pkg
          ];

          services.calibre-web = {
            enable = true;
            package = calibre-pkg;

            listen = {
              ip = "127.0.0.1";
              port = cfg.port;
            };

            options = {
              calibreLibrary = "/mnt/drive/Books/";
              enableBookConversion = true;
              enableKepubify = true;
              enableBookUploading = true;
            };
          };

          # books stay owned by ayoub; the shared group gives calibre-web read-write access
          users.groups.media = { };
          users.users.calibre-web.extraGroups = [ "media" ];

          systemd.services.calibre-web.unitConfig.RequiresMountsFor = [ "/mnt/drive/Books" ];

          svc.caddy.hosts."calibre-web.poire.me".extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
        }

        # the token in /kobo/<token>/… authenticates the e-reader; nothing else is reachable here
        (lib.mkIf (cfg.kobo-lan.interface != null) {
          svc.caddy.hosts."http://:${toString cfg.kobo-lan.port}".extraConfig = ''
            handle /kobo/* {
              reverse_proxy localhost:${toString cfg.port}
            }
            handle {
              respond 404
            }
          '';
          networking.firewall.interfaces.${cfg.kobo-lan.interface}.allowedTCPPorts = [
            cfg.kobo-lan.port
          ];
        })
      ];
    };
}
