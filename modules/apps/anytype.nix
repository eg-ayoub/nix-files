{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.apps.anytype;
in
{
  options.apps.anytype = {
    enable = lib.mkEnableOption "enable anytype";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      anytype
    ];
  };
}
