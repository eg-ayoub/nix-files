{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
  ];

  programs.hyprland.enable = true;

}
