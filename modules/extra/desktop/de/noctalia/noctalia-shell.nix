{ ... }:
{
  flake.nixosModules.noctalia-shell =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = [ pkgs.noctalia-shell ];
      };
    };
}
