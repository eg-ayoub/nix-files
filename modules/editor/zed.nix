{ config, lib, pkgs, ... }:
let
  cfg = config.editor.zed;
in
{

  options.editor.zed = {
    enable = lib.mkEnableOption "enable zed";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zed-editor
    ];
  };

}
