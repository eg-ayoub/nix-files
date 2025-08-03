{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.godot;
in
{
  options.apps.godot = {
    enable = lib.mkEnableOption "enable godot tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      godot-mono
    ];
  };
}
