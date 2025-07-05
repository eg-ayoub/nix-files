{ lib, config, ... }: 
let
  cfg = config.system.networkmanager;
in
{
  options.system.networkmanager = {
    enable = lib.mkEnableOption "Enable NetworkManger";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
