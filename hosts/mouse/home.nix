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
  shell.direnv.enable = true;

  editor.nvim.enable = true;
  editor.servers.enable = true;

  hyprland.hyprland.enable = true;

  kitty.enable = true;

  apps.chrome.enable = true;
  apps.slack.enable = true;
  apps.logseq.enable = true;
  apps.spotify.enable = true;
  apps.pass.enable = true;
  # apps.devcontainer.enable = true;

  git.enable = true;
  git.email = "ayoub.nasr@scality.com";
  git.enable-signing = true;

  ssh.enable = true;
}
