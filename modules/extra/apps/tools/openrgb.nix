{ ... }:
{
  flake.nixosModules.openrgb =
    { pkgs, ... }:
    {
      config = {
        services.udev.packages = with pkgs; [
          openrgb
        ];
        services.hardware.openrgb = {
          enable = true;
          package = pkgs.openrgb;
        };
      };
    };
}
