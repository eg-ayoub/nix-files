{ self, ... }:
{
  flake.nixosModules.xfce =
    { ... }:
    {
      imports = [
        self.nixosModules.xserver
      ];

      config = {
        services = {
          pulseaudio.enable = false;
          xserver = {
            displayManager.lightdm.enable = true;
            desktopManager.xfce.enable = true;
          };
        };
      };
    };
}
