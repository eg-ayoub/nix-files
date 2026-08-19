{ self, ... }:
{
  flake.nixosModules.niri-de =
    { ... }:
    {
      imports = [
        self.nixosModules.niri
        self.nixosModules.noctalia-shell
      ];

      config = {
        services.gnome.gnome-keyring.enable = true;
      };
    };
}
