{ ... }:
{
  flake.nixosModules.kdeconnect =
    { ... }:
    {
      config = {
        programs.kdeconnect.enable = true;
      };
    };
}
