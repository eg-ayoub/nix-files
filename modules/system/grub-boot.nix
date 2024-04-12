{ lib, config, ... }:

let
  cfg = config.system.grub-boot;
in
{

  options.system.grub-boot = {
    enable = lib.mkEnableOption "enable grub";
    boot-device = lib.mkOption {
        default="/dev/sda";
        description= "Which device to boot from";
        type = lib.types.str;
    };
  }; 
 
  config = lib.mkIf cfg.enable {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = cfg.boot-device;
    boot.loader.grub.useOSProber = true;
  };
}
