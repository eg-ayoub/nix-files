{ pkgs, lib, config, ... }:
let
  cfg = config.cont.homeassistant;
in
{
  options.cont.homeassistant = {
    enable = lib.mkEnableOption "enable Home Assistant";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8123 ];
    virtualisation.oci-containers.containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      environment = {
        TZ="Etc/CET";
      };
      volumes = [
        "/home/ayoub/assistant:/config"
      ];
      autoStart = false;
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
