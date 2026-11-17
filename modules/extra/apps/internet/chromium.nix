{ inputs, ... }:
{
  flake.nixosModules.chromium =
    { pkgs, ... }:
    {
      config = {
        # a chromium-based browser, whichever one is current: today Helium
        environment.systemPackages = [
          inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
