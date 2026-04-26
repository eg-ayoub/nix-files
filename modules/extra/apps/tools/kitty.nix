{ ... }:
{
  flake.nixosModules.kitty =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          kitty
        ];
      };
    };
}
