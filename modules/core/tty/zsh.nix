{ ... }:
{
  flake.nixosModules.zsh =
    { ... }:
    {
      config = {
        programs.zsh.enable = true;
      };
    };
}
