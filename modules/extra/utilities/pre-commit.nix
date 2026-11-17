{ ... }:
{
  flake.nixosModules.pre-commit =
    { pkgs, ... }:
    {
      config = {
        # pre-commit and the tools its hooks call (.pre-commit-config.yaml)
        environment.systemPackages = with pkgs; [
          pre-commit
          nixfmt-tree
          statix
          deadnix
        ];
      };
    };
}
