{ pkgs, lib, config, ... }:
let
  cfg = config.cont.invidious-companion;
in
{
  options.cont.invidious-companion = {
    enable = lib.mkEnableOption "enable Invidious-server";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8282 ];
    virtualisation.oci-containers.containers.invidious-companion = {
      image = "quay.io/invidious/invidious-companion:latest";
      ports = [
        "8282:8282"
      ];
      volumes = [
        "/mnt/drive/invidious-companion/companioncache:/var/tmp/youtubei.js:rw"
      ];
      environmentFiles = [
        "/mnt/drive/invidious-companion/.env"
      ];
      autoStart = true;
    };
  };
}
