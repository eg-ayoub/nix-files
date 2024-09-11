{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.rpcs3;
in
{
  options.apps.rpcs3 = {
    enable = lib.mkEnableOption "enable rpcs3";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rpcs3
    ];
  };
}
