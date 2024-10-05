{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.handbrake;
in
{
  options.apps.handbrake = {
    enable = lib.mkEnableOption "enable Handbrake transcoder";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      handbrake
    ];
  };
}
