{ ... }:
{
  flake.nixosModules.openssh =
    { lib, config, ... }:
    let
      cfg = config.svc.openssh;
    in
    {
      options.svc.openssh = {
        password-auth = lib.mkEnableOption "enable SSH password auth";
      };

      config = {
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = cfg.password-auth;
        };
      };
    };
}
