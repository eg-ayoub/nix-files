{ ... }:
{
  flake.nixosModules.nsusb =
    { pkgs, ... }:
    {
      config = {
        services.udev.packages = with pkgs; [
          ns-usbloader
        ];
        environment.systemPackages = with pkgs; [
          ns-usbloader
        ];
      };
    };
}
