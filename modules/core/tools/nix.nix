{ ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      config = {
        nixpkgs.config.allowUnfree = true;

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
}
