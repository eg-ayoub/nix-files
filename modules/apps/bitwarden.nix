{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.bitwarden;
in
{
  options.apps.bitwarden = {
    enable = lib.mkEnableOption "enable bitwarden";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
      bitwarden-menu
    ]; 
  };
}
