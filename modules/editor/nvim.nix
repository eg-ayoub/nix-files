{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.editor.nvim;
in
{
  options.editor.nvim = {
    enable = lib.mkEnableOption "enable nvim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      # needed for copilot
      luajitPackages.tiktoken_core
      copilot-language-server
      nodejs
    ];
    programs.neovim = {
      enable = true;
    };
    home.file = {
      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/nix-files/dotfiles/nvim/dot-config/nvim";
      };
    };
  };
}
