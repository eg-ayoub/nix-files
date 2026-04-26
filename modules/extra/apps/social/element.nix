{ ... }:
{
  flake.nixosModules.element =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          element-desktop
        ];
      };
    };
}
