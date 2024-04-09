{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.shell.starship;
in
{
  options.shell.starship = {
    enable = lib.mkEnableOption "enable starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      settings = {
        format = lib.concatStrings [
          "$line_break"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_status"
          "$git_state"
          "$line_break"
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

}
