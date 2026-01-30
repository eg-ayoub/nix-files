{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.system.packages;
  mywalls = (pkgs.callPackage ../../pkgs/mywalls.nix {}).mywalls;
in
{

  options.system.packages = {
    plasma6.enable = lib.mkEnableOption "install plasma6";
    gaming.enable = lib.mkEnableOption "install steam and gaming utilities"; 
  };

  config = lib.mkMerge [
    {environment.systemPackages = with pkgs; [
      vim
      git
      curl
      lshw
      firefox
      neofetch
      wl-clipboard
      wtype
      brightnessctl
      pciutils
    ];
    }
    (lib.mkIf cfg.plasma6.enable {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      environment.systemPackages = with pkgs;[
        # kdePackages.koi
        kdePackages.kconfig
        variety
      ] ++ [ mywalls ];
    })
    (lib.mkIf cfg.gaming.enable {
      programs.steam = {
        enable = true;
        rocksmithPatch.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
      };
      environment.systemPackages = with pkgs; [
        goverlay
        mangohud
        # TODO: move this out of here
        # nvtopPackages.full
      ];
      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/ayoub/.steam/root/compatibilitytools.d";
      };
      programs.gamemode.enable = true;
    })
  ];
}
