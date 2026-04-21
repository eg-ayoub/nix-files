{ inputs, ... }:
{
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-rocksmith.nixosModules.default
      ];

      config = {
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
        ];
        # environment.sessionVariables = {
        # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/ayoub/.steam/root/compatibilitytools.d";
        # };
        programs.gamemode.enable = true;
      };
    };
}
