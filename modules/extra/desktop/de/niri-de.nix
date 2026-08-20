{ self, ... }:
{
  flake.nixosModules.niri-de =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.noctalia-shell
        self.nixosModules.nautilus
      ];

      config = {
        services.gnome.gnome-keyring.enable = true;
        environment.systemPackages = [
          pkgs.adw-gtk3
          pkgs.adwaita-icon-theme
          pkgs.capitaine-cursors
        ];
      };
    };
}
