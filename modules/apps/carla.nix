{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.carla;
in
{
  options.apps.carla = {
    enable = lib.mkEnableOption "enable carla";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      carla
      # yabridge
      # yabridgectl
    ];
  };
}
