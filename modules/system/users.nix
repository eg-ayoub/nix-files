{ pkgs, ... }: {

  users.users.ayoub = {
    name = "ayoub";
    home = "/home/ayoub";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

}
