{ ... }:
{
  flake.nixosModules.lutris =
    { pkgs, ... }:
    {
      config = {
        nixpkgs.overlays = [
          (_: prev: {
            openldap = prev.openldap.overrideAttrs {
              doCheck = !prev.stdenv.hostPlatform.isi686;
            };
          })
        ];
        environment.systemPackages = with pkgs; [
          lutris
        ];
      };
    };
}
