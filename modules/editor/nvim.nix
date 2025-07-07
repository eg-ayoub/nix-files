{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.editor.nvim;
in
{
  options.editor.nvim = {
    enable = lib.mkEnableOption "enable nvim";
    fake_wal = lib.mkEnableOption "add fake wal file";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      # needed for copilot
      luajitPackages.tiktoken_core
      copilot-language-server
      nodejs
    ];
    home.sessionVariables = {
      COPILOT_LS = "${pkgs.copilot-language-server}/bin/copilot-language-server";
    };
    programs.neovim = {
      enable = true;
    };
    home.file = {
      ".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/nix-files/dotfiles/nvim/dot-config/nvim";
      };
      ".cache/wal/colors-wal.vim" = lib.mkIf cfg.fake_wal {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/nix-files/dotfiles/nvim/fake-wal.vim";
      };
    };
  };
}
