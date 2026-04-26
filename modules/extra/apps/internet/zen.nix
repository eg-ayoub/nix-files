{ inputs, ... }:
{
  flake.nixosModules.zen-browser =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = [
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
