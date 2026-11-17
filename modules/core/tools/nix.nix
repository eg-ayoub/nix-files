{ self, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      imports = [
        self.nixosModules.pre-commit
      ];

      config = {
        nixpkgs.config.allowUnfree = true;

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
}
