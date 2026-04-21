{ self, ... }:
{
  flake.nixosModules.starship-zsh =
    { lib, ... }:
    {
      imports = [
        self.nixosModules.zsh
      ];

      config = {
        programs.starship = {
          enable = true;
          # minimal starship prompt, will be overriden in dotfiles
          settings = {
            format = lib.concatStrings [
              "$directory"
              "$git_branch"
              "$character"
            ];
            add_newline = true;
            directory.format = "[:](bold green)[$path]($style)[$read_only]($read_only_style) ";
            character = {
              success_symbol = "[\\$](bold green)";
              error_symbol = "[\\$](bold red)";
            };
          };
        };
      };
    };
}
