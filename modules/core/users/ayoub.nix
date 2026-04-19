{ ... }:
{
  flake.nixosModules.ayoub-user =
    { pkgs, ... }:
    {
      config = {

        users.users.ayoub = {
          uid = 1000;
          name = "ayoub";
          home = "/home/ayoub";
          description = "ol' trickster boi";
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
            # "docker"
            # "gamemode"
            # "libvirtd"
            # "podman"
          ];
          # shell = pkgs.zsh;
        };

        nix.settings.trusted-users = [
          "root"
          "ayoub"
        ];
      };
    };
}
