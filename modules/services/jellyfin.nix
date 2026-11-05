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
        services.jellyfin = {
          enable = true;
          user = "ayoub";
        };
        core.users.ayoub.extra-groups = [ "render" ];
        svc.caddy.hosts."jellyfin.poire.me".extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
    };
}
