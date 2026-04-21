{ ... }:
{
  flake.nixosModules.jellyfin-desktop =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          jellyfin-desktop
        ];
      };
    };
}
