{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.deluge;
in
{
  options.apps.deluge = {
    enable = lib.mkEnableOption "enable deluge";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      deluge
    ];
  };
}
