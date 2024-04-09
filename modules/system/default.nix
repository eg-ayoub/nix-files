{ inputs, pkgs, config, ... }: {
  imports = [
    ./boot.nix
    ./users.nix
    ./misc.nix
    ./packages.nix
    ./shell.nix
  ];
}
