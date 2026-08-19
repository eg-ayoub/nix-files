{ self, ... }:
{
  flake.nixosModules.niri =
    { ... }:
    {
      imports = [
        self.nixosModules.sddm
      ];

      config = {
        programs.niri = {
          enable = true;
          useNautilus = true;
        };
      };
    };
}
