{ config, lib, pkgs, ...}:
let
  cfg = config.shell.extras;
in
{
  options.shell.extras = {
    enable = lib.mkEnableOption "enable shell extra programs";  
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
    ]; 
  };
}
