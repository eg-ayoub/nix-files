{ ... }:
{
  flake.nixosModules.tailscale =
    { ... }:
    {
      config = {
        services.tailscale.enable = true;
      };
    };
}
