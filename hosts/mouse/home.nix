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
  shell.extras.enable = true;

  editor.nvim.enable = true;
  editor.servers.enable = true;
  editor.zed.enable = true;

  hyprland.hyprland.enable = true;
  hyprland.kanshi.enable = true;
  hyprland.kanshi.profiles = [
    { 
      output.criteria = "eDP-1";
      output.scale = 1.25;
    }
    { output.criteria = "DP-1"; }
    {
      profile.name = "undocked";
      profile.outputs = [
        { criteria = "eDP-1"; }
      ];
    }
    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.5;
          position = "1920,0";
        }
        { 
          criteria = "DP-1";
          position = "0,0";
        }
      ];
    }
  ];

  kitty.enable = true;

  apps.chrome.enable = true;
  apps.slack.enable = true;
  apps.spotify.enable = true;
  apps.pass.enable = true;
  apps.bitwarden.enable = true;
  # apps.devcontainer.enable = true;
  apps.jmp.enable = true;

  git.enable = true;
  git.email = "ayoub.nasr@scality.com";
  git.enable-signing = true;

  virt.enable = true;

  ssh.enable = true;
}
