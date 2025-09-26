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
          bind_hosts = [ "127.0.0.1" "::1" ];
          port = 53;
        };
      };
    };
  };
}
