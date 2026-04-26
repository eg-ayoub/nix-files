{ self, ... }:
{
  flake.nixosModules.nvim =
    { ... }:
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
      };
    };
}
