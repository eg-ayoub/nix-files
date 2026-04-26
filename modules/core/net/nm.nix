{ ... }:
{
  flake.nixosModules.networking =
    { ... }:
    {
      config = {
        networking.networkmanager.enable = true;
      };
    };
}
