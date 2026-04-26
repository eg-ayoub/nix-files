{ ... }:
{
  flake.nixosModules.xserver =
    { ... }:
    {
      config = {
        services.xserver.enable = true;
      };
    };
}
