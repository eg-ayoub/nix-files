{ inputs, pkgs, config, ... }: {

  imports = [
    ./shell
    ./editor
    ./hyprland
    ./kitty
    ./apps
    ./git
    ./ssh
  ];

}
