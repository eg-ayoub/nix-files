{ inputs, pkgs, config, ... }: {

  imports = [
    ./shell
    ./editor
    ./hyprland
    ./kitty
  ];

}
