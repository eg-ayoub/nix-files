{ pkgs, lib, config, ... }:
let
  cfg = config.svc.adguardhome;
in
{
  options.svc.adguardhome = {
    enable = lib.mkEnableOption "enable AdGuardHome";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.adguardhome
    ];
    networking.firewall.allowedUDPPorts = [ 53 67 68 546 547 ];
    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      openFirewall = true;
      allowDHCP = true;
    };
  };
}
