{ ... }:
{
  flake.nixosModules.firejail =
    { ... }:
    {
      config = {
        programs.firejail.enable = true;
      };
    };
}
