{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.editor.servers;
in
{
  options.editor.servers = {
    enable = lib.mkEnableOption "enable LSP servers";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixd
      shellcheck
      nodePackages.bash-language-server
      nodePackages.pyright
      yaml-language-server
      marksman
      gopls
      clang-tools
      cmake-language-server
      lua-language-server
    ];
  };
}
