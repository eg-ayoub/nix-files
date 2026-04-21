{ ... }:
{
  flake.nixosModules.lutris =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          lutris
        ];
      };
    };
}
