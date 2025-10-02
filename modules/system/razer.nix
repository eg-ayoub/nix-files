{ lib, config, pkgs, ... }: 

let
  cfg = config.system.razer;
in
{

  options.system.razer = {
    enable = lib.mkEnableOption "enable razer tools";
  }; 
 
  config = lib.mkIf cfg.enable {
    hardware.openrazer.enable = true;
    environment.systemPackages = with pkgs; [
      openrazer-daemon
      polychromatic
      razergenie
      razer-cli
    ];
    users.users.ayoub.extraGroups = [ "openrazer" ];
  };

}
