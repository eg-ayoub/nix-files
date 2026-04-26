{ ... }:
{
  flake.nixosModules.grub-boot =
    { lib, config, ... }:
    let
      cfg = config.core.boot.grub-boot;
    in
    {
      options.core.boot.grub-boot = {
        boot-device = lib.mkOption {
          type = lib.types.str;
          default = "/dev/sda";
          description = "the device from which grub boots";
        };
      };

      config = {
        boot.loader.grub = {
          enable = true;
          device = cfg.boot-device;
          useOSProber = true;
        };
      };
    };
}
