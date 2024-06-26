{ pkgs, ... }: {

  users.users.ayoub = {
    name = "ayoub";
    home = "/home/ayoub";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "gamemode" ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ "root" "ayoub" ];

}
