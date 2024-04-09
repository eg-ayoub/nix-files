{ pkgs, ... }: {

  users.users.ayoub = {
    name = "ayoub";
    home = "/home/ayoub";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

}
