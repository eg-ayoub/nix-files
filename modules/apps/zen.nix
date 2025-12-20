{ lib, pkgs, inputs, config, ... }:

let
  cfg = config.apps.zen-browser;
in
{
  options.apps.zen-browser = {
    enable = lib.mkEnableOption "enable zen browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
