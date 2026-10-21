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

        # pre-built packages of numtide's llm-agents.nix (pi)
        nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
        nix.settings.extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];

        environment.systemPackages = with pkgs; [
          nixfmt-tree
        ];
      };
    };
}
