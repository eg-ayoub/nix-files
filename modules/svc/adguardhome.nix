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
    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      openFirewall = true;
      settings = {
        dns = {
          bind_hosts = [ "100.107.41.45" "fd7a:115c:a1e0::3b01:2985" ];
          port = 53;
        };
      };
    };
  };
}
