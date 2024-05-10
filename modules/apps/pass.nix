{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.apps.pass;
in
{
  options.apps.pass = {
    enable = lib.mkEnableOption "enable pass";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pass
      tessen
    ];
  };
}
