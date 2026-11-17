{ ... }:
{
  flake.nixosModules.openrgb =
    { ... }:
    {
      config = {
        services.hardware.openrgb.enable = true;
      };
    };
}
