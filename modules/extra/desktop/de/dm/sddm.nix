{ ... }:
{
  flake.nixosModules.sddm =
    { ... }:
    {
      config = {
        services = {
          displayManager.sddm = {
            enable = true;
            wayland.enable = true;
          };
        };
      };
    };
}
