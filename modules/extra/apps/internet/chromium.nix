{ ... }:
{
  flake.nixosModules.chromium =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          chromium
        ];
      };
    };
}
