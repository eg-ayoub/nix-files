{ pkgs, ... }: {

  users.users.ayoub = {
    uid = 1000;
    name = "ayoub";
    home = "/home/ayoub";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "gamemode" "libvirtd" "podman" ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ "root" "ayoub" ];

}
