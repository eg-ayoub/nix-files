{ ... }:
{
  flake.nixosModules.openssh =
    { lib, config, ... }:
    let
      cfg = config.services.openssh;
    in
    {
      options.services.openssh = {
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
