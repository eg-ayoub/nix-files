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
      };

      config = {
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

        svc.caddy.hosts."calibre-web.poire.me".extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
      };
    };
}
