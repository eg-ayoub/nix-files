{ ... }:
{
  flake.nixosModules.steam =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.app.steam;
    in
    {
      # imports = [
      #   inputs.nixos-rocksmith.nixosModules.default
      # ];

      options.app.steam = {
        remote-play = lib.mkEnableOption "Steam Remote Play hosting, with its firewall ports open";
      };

      config = {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = cfg.remote-play;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
          # rocksmithPatch.enable = true;
          gamescopeSession.enable = true;
          protontricks.enable = true;
        };
        # environment.systemPackages = with pkgs; [
        #   goverlay
        #   mangohud
        # ];
        # environment.sessionVariables = {
        # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/ayoub/.steam/root/compatibilitytools.d";
        # };
        programs.gamemode.enable = true;
        core.users.ayoub.extra-groups = [ "gamemode" ];
      };
    };
}
