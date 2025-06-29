{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.kitty;
in
{
  options.kitty = {
    enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];
    home.file = {
      ".config/kitty" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/nix-files/dotfiles/kitty/dot-config/kitty";
      };
    };
  };

}
