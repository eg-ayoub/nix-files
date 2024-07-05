{ lib, config, ... }:
let
  cfg = config.hyprland.kanshi;
in
{
  options.hyprland.kanshi = {
    enable = lib.mkEnableOption "enable kanshi monitor manager";
    profiles = lib.mkOption {
      default = {};
      description = "Display profiles for kanshi";
      type = lib.types.listOf lib.types.attrs;
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      settings = cfg.profiles;
      systemdTarget = "graphical-session.target";
    };
  };
}
