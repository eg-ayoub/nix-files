{ inputs, ... }:
{
  flake.nixosModules.chromium =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = [
          inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
