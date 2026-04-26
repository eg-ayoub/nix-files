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
        dependencies = oldAttrs.dependencies ++ [ pkgs.calibre-web.optional-dependencies.kobo ];
      });
    in
    {
      options.svc.calibre-web = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "host on which to serve calibre-web";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 8083;
          description = "port on which to serve calibre-web";
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
            ip = cfg.host;
            port = cfg.port;
          };

          openFirewall = true;

          user = "ayoub";
          group = "users";

          options = {
            # calibreLibrary = /mnt/drive/calibre-web;
            enableBookConversion = true;
            enableKepubify = true;
            enableBookUploading = true;
          };
        };
      };
    };
}
