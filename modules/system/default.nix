{ inputs, pkgs, config, ... }: {
  imports = [
    ./grub-boot.nix
    ./systemd-boot.nix
    ./users.nix
    ./misc.nix
    ./packages.nix
    ./shell.nix
    ./gfx.nix
    ./fonts.nix
    ./gpg.nix
    ./sound.nix
    ./networking.nix
    ./locale.nix
    ./docker.nix
    ./gpu
    ./legion.nix
    ./virt.nix
  ];
}
