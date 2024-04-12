{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.kitty;
in
{
  options.kitty = {
    enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}
