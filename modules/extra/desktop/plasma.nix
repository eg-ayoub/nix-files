{ ... }:
{
  flake.nixosModules.plasma6 =
    { pkgs, ... }:
    {
      config = {
        services = {
          displayManager.sddm = {
            enable = true;
            wayland.enable = true;
          };
          desktopManager.plasma6.enable = true;
        };
        environment.systemPackages = with pkgs; [
          kdePackages.kconfig
        ];
      };
    };
}
