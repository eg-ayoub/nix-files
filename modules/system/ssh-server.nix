{ lib, config, pkgs, ... }: 

let
  cfg = config.system.ssh-server;
in
{

  options.system.ssh-server = {
    enable = lib.mkEnableOption "enable SSH server";
    passwordAuth = lib.mkEnableOption "enable SSH password auth";
  }; 
 
  config = lib.mkIf cfg.enable {
    services.openssh = lib.mkIf cfg.enable {
      enable = true;
      settings.PasswordAuthentication = cfg.passwordAuth;
    };
  };

}
