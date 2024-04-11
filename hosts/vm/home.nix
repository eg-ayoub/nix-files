{ ... } : {
  
  imports = [
    ./../../modules
  ];

  home.username = "ayoub";
  home.homeDirectory = "/home/ayoub";

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  shell.zsh.enable = true;
  shell.starship.enable = true;

  editor.nvim.enable = true;
}
