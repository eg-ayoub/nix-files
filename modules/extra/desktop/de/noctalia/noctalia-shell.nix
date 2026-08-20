{ ... }:
{
  flake.nixosModules.noctalia-shell =
    { ... }:
    {
      config = {
        programs.noctalia = {
          enable = true;
          recommendedServices.enable = true;
        };
      };
    };
}
