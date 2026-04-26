{ ... }:
{
  flake.nixosModules.discord =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          legcord
        ];
      };
    };
}
