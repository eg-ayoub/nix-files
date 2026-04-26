{ ... }:
{
  flake.nixosModules.polkit =
    { ... }:
    {
      config = {
        security.polkit.enable = true;
      };
    };
}
