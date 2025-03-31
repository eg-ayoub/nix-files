{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.obs;
in
{
  options.apps.obs = {
    enable = lib.mkEnableOption "enable obs";
  };

  config = lib.mkIf cfg.enable {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
        ];
      };
  };
}
