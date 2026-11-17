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
      options.app.steam = {
        remote-play = lib.mkEnableOption "Steam Remote Play hosting, with its firewall ports open";
      };

      config = {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = cfg.remote-play;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
          gamescopeSession.enable = true;
          protontricks.enable = true;
        };
        programs.gamemode.enable = true;
        core.users.ayoub.extra-groups = [ "gamemode" ];
      };
    };
}
