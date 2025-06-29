{ inputs, pkgs, config, ... }: {

  imports = [
    ./shell
    ./editor
    ./kitty
    ./apps
    ./git
    ./ssh
    ./virt
  ];

}
