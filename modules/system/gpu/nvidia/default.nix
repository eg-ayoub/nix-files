{ lib, pkgs, config, ... }: 

let
  cfg = config.system.gpu.nvidia;
in
{

  options.system.gpu.nvidia = {
    enable = lib.mkEnableOption "enable nvidia";
    profile = lib.mkOption {
      default = {};
      description = "Which nvidia profile to set up";
      type = lib.types.attrs;
    };
  };

  config = lib.mkIf cfg.enable {

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = cfg.profile;

  }; 
}
