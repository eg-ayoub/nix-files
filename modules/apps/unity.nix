{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.unityhub;
in
{
  options.apps.unityhub = {
    enable = lib.mkEnableOption "enable unityhub tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      unityhub
    ];
  };
}
