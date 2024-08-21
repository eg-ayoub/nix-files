{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.protonvpn;
in
{
  options.apps.protonvpn = {
    enable = lib.mkEnableOption "enable protonvpn";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      protonvpn-gui
      protonvpn-cli
    ];
  };
}
