{ inputs, pkgs, config, ... }: {
  imports = [
    ./docker.nix
    ./fcitx.nix
    ./fonts.nix
    ./gpg.nix
    ./grub-boot.nix
    ./ld.nix
    ./legion.nix
    ./locale.nix
    ./misc.nix
    ./networking.nix
    ./ns-usb.nix
    ./packages.nix
    ./razer.nix
    ./shell.nix
    ./sound.nix
    ./ssh-server.nix
    ./systemd-boot.nix
    ./users.nix
    ./vial.nix
    ./virt.nix
    ./wine.nix
  ];
}
