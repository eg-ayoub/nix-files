{ pkgs, lib, config, ... }:
let
  cfg = config.svc.tailscale;
in
{
  options.svc.tailscale = {
    enable = lib.mkEnableOption "enable TailScale";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
