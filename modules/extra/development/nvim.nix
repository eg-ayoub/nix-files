{ ... }:
{
  flake.nixosModules.nvim =
    { pkgs, ... }:
    {
      config = {
        programs.neovim = {
          enable = true;
          withPython3 = true;
        };
        environment.systemPackages = with pkgs; [
          tree-sitter
          ripgrep
        ];
      };
    };
}
