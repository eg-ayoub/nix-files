{ pkgs, lib, config, ... }:
let
  cfg = config.svc.invidious;
in
{
  options.svc.invidious = {
    enable = lib.mkEnableOption "enable Invidious";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8090 ];
    services.invidious = {
      enable = true;
      domain = "tyke";
      port = 8090;
      settings = {
        external_port = 8090;
        db = {
          user = "invidious";
          dbname = "invidious";
        };
      };
      extraSettingsFile = "/mnt/drive/invidious/config.json";
    };
  };
}
