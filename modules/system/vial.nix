{ lib, pkgs, config, ... }:
let
  cfg = config.system.vial;
in
{
  options.system.vial = {
    enable = lib.mkEnableOption "enable vial tools";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = with pkgs;[
      vial
    ];
    environment.systemPackages = with pkgs; [
      vial
    ];
  };
}
