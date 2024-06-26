{ lib, pkgs, config, ... }: 

let
  cfg = config.system.packages;
  mywalls = (pkgs.callPackage ../../pkgs/mywalls.nix {}).mywalls;
in
{

  options.system.packages = {
    hyprland.enable = lib.mkEnableOption "install hyprland";
    plasma6.enable = lib.mkEnableOption "install plasma6";
    gaming.enable = lib.mkEnableOption "install steam and gaming utilities"; 
  };

  config = lib.mkMerge [
    {environment.systemPackages = with pkgs; [
      vim
      # python3
      git
      curl
      lshw
      firefox
      neofetch
      wl-clipboard
      wtype
      brightnessctl
    ];}
    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;
      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
      services.gvfs.enable = true;
      services.tumbler.enable = true;
      programs.xfconf.enable = true;
      services.displayManager.sddm = {
        enable = true;
        package = pkgs.libsForQt5.sddm;
        wayland.enable = true;
        extraPackages = with pkgs; [
          libsForQt5.qt5.qtquickcontrols2
        ];
        theme = "Elegant";
      };
      environment.systemPackages = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        kdePackages.polkit-kde-agent-1
        (elegant-sddm.override {
          themeConfig.General = {
            background = "${mywalls}/nixos/nix-wallpaper-moonscape.png";
          };
        })
        libnotify
      ] ++ [ mywalls ];
      services.gnome.gnome-keyring.enable = true;
    })
    (lib.mkIf cfg.plasma6.enable {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.wayland.enable = true;
    })
    (lib.mkIf cfg.gaming.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };
      environment.systemPackages = with pkgs; [
        goverlay
        mangohud
        protonup
      ];
      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/ayoub/.steam/root/compatibilitytools.d";
      };
      programs.gamemode.enable = true;
    })
  ];
}
