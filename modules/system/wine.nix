{ pkgs, lib, config, ... }: 
let
  cfg = config.system.wine;
in
{
  options.system.wine = {
    enable = lib.mkEnableOption "Enable wine";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # wineWowPackages.waylandFull
      wineWowPackages.stable
      winetricks
    ];
  };
}
