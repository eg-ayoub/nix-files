{ ... }:
{
  flake.nixosModules.systemd-boot =
    { ... }:
    {
      config = {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      };
    };
}
