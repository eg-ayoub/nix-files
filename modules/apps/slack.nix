{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.slack;
in
{
  options.apps.slack = {
    enable = lib.mkEnableOption "enable slack";
    wl = lib.mkEnableOption "launch wayland slack";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ]; 
  };
}
