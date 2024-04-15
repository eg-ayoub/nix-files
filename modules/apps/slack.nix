{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.slack;
in
{
  options.apps.slack = {
    enable = lib.mkEnableOption "enable slack";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
