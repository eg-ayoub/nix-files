{ lib, pkgs, inputs, config, ... }:

let
  cfg = config.apps.wal;
in
{
  options.apps.wal = {
    enable = lib.mkEnableOption "enable pywal16";
    kde-wal-reload = lib.mkEnableOption "install wal-reload script for kde";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      pywal16
      (lib.mkIf cfg.kde-wal-reload (writeShellApplication {
        name = "kde-wal-reload";
        text = builtins.readFile ../../dotfiles/scripts/dot-local/bin/kde-wal-reload.sh;
      }))
    ];
  };
}
