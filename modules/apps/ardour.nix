{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.ardour;
in
{
  options.apps.ardour = {
    enable = lib.mkEnableOption "enable ardour";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ardour
    ]; 
  };
}
