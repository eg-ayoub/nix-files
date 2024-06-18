{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.discord;
in
{
  options.apps.discord = {
    enable = lib.mkEnableOption "enable discord";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      armcord
    ]; 
  };
}
