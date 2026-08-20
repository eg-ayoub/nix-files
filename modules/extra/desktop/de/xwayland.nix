{ ... }:
{
  flake.nixosModules.xwayland =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          xwayland-satellite
        ];
      };
    };
}
