{ ... }:
{
  flake.nixosModules.jellyfin =
    { pkgs, ... }:
    {
      config = {
        environment.systemPackages = [
          pkgs.jellyfin
          pkgs.jellyfin-web
          pkgs.jellyfin-ffmpeg
        ];
        services.jellyfin.enable = true;

        # media stays owned by ayoub; the shared group gives jellyfin read-write access
        users.groups.media = { };
        users.users.jellyfin.extraGroups = [
          "media"
          "render"
        ];
        core.users.ayoub.extra-groups = [ "media" ];
        svc.caddy.hosts."jellyfin.poire.me".extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
    };
}
