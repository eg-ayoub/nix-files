{ ... }:
{
  flake.nixosModules.gimp =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          gimp
        ];
      };
    };
}
