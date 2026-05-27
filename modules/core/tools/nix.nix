{ self, ... }:
{
  flake.nixosModules.nix =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.pre-commit
      ];

      config = {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.android_sdk.accept_license = true;

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        environment.systemPackages = with pkgs; [
          nixfmt-tree
        ];
      };
    };
}
