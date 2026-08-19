{ self, ... }:
{
  flake.nixosModules.plasma6 =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.sddm
      ];

      config = {
        services.desktopManager.plasma6.enable = true;
        environment.systemPackages = with pkgs.kdePackages; [
          kconfig
          filelight
          oxygen
          oxygen-icons
          oxygen-sounds
        ];
      };
    };
}
