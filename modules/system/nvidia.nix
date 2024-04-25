{ lib, pkgs, config, ... }: 

let
  cfg = config.system.nvidia;
in
{

  options.system.nvidia = {
    enable = lib.mkEnableOption "install nvidia";
    profile = lib.mkOption {
      default = "mouse";
      description = "Which nvidia profile to set up";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    "mouse" = {
      services.videoDrivers = [ "nvidia" ];
    
      hardware.nvidia = {
        modesetting.enable = true;
        # can cause issues
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
  }.${cfg.profile};
}
