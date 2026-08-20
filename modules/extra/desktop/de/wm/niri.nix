{ self, ... }:
{
  flake.nixosModules.niri =
    { ... }:
    {
      imports = [
        self.nixosModules.sddm
        self.nixosModules.xwayland
      ];

      config = {
        programs.niri = {
          enable = true;
          useNautilus = true;
        };
      };
    };
}
