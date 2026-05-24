{ self, ... }:
{
  flake.nixosModules.nvim =
    { pkgs, ... }:
    {
      imports = [
        # needed for ripgrep
        self.nixosModules.terminal-toolbox
      ];

      config = {
        programs.neovim = {
          enable = true;
          withPython3 = true;
        };
        environment.systemPackages = with pkgs; [ tree-sitter ];
      };
    };
}
