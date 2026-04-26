{ ... }:
{
  flake.nixosModules.vial =
    { pkgs, ... }:
    {
      config = {
        services.udev.packages = with pkgs; [
          vial
        ];
        environment.systemPackages = with pkgs; [
          vial
        ];
      };
    };
}
