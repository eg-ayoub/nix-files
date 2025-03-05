{ lib, config, pkgs, ... }: 

let
  cfg = config.system.legion;
in
{

  options.system.legion = {
    enable = lib.mkEnableOption "enable legion tools";
  }; 
 
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lenovo-legion
    ];
    boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
    boot.kernelModules = [ "lenovo-legion-module" ];

  };

}
