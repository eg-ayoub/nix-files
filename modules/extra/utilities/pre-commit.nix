{ ... }:
{
  flake.nixosModules.pre-commit =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          pre-commit
        ];
      };
    };
}
