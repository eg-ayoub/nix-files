{ lib, pkgs, config, ... }: 

let
  cfg = config.system.packages;
in
{

  options.system.packages = {
    hyprland.enable = lib.mkEnableOption "install hyprland";
    plasma6.enable = lib.mkEnableOption "install plasma6";
  };

  config = lib.mkMerge [
    {environment.systemPackages = with pkgs; [
      vim
      git
      curl
      firefox
    ];}
    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;
    })
    (lib.mkIf cfg.plasma6.enable {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.wayland.enable = true;
    })
  ];
}
