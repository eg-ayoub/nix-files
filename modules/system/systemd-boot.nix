{ lib, config, ... }: 

let
  cfg = config.system.systemd-boot;
in
{

  options.system.systemd-boot = {
    enable = lib.mkEnableOption "enable systemd-boot";
  }; 
 
  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };

}
