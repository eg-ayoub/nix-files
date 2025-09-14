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
  shell.direnv.enable = true;
  shell.extras.enable=true; 

  editor.nvim.enable = true;
  editor.servers.enable = true;
  # editor.zed.enable = true;

  kitty.enable = true;

  # apps.carla.enable = true;
  # apps.anytype.enable = true;
  apps.deluge.enable = true;
  apps.discord.enable = true;
  # apps.handbrake.enable = true;
  apps.jmp.enable = true;
  apps.lutris.enable = true;
  apps.musescore.enable = true;
  apps.protonvpn.enable = true;
  apps.rpcs3.enable = true;
  apps.spotify.enable = true;
  apps.vlc.enable = true;
  apps.zen-browser.enable = true;
  # apps.ipod.enable = true;
  apps.obs.enable = true;
  apps.wal.enable = true;
  apps.wal.kde-wal-reload = true;
  apps.godot.enable = true;
  apps.godot.script = true;

  git.enable = true;
  git.email = "ayoub.nasr@proton.me";
  #git.enable-signing = true;

  virt.enable = true;

  ssh.enable = true;
}
