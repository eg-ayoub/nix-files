{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.teamspeak;
in
{
  options.apps.teamspeak = {
    enable = lib.mkEnableOption "enable teamspeak desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      teamspeak6-client
    ]; 
  };
}
