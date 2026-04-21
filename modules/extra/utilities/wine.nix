{ ... }:
{
  flake.nixosModules.wine =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          wineWow64Packages.stable
          winetricks
        ];
      };
    };
}
