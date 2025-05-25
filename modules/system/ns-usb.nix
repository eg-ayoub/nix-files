{ lib, pkgs, config, ... }:
let
  cfg = config.system.ns-usbloader;
in
{
  options.system.ns-usbloader = {
    enable = lib.mkEnableOption "enable ns-usbloader tools";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = with pkgs;[
      ns-usbloader
    ];
    environment.systemPackages = with pkgs; [
      ns-usbloader
    ];
  };
}
