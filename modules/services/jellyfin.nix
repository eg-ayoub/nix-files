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
          openFirewall = true;
          user = "ayoub";
        };
        core.users.ayoub.extra-groups = [ "render" ];
      };
    };
}
