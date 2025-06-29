{ ... } : {

  imports = [
    ./../../modules
  ];

  home.username = "ayoub";
  home.homeDirectory = "/home/ayoub";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  shell.zsh.enable = true;
  shell.starship.enable = true;
  shell.extras.enable = true;

  editor.nvim.enable = true;
  editor.nvim.fake_wal = true;
  editor.servers.enable = true;

  git.enable = true;
  git.email = "ayoub.nasr@proton.me";
  # git.enable-signing = true;

  virt.enable = true;

  ssh.enable = true;
}
