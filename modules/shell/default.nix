{ inputs, pkgs, config, ... }: {

  imports = [
    ./zsh.nix
    ./starship.nix
    ./direnv.nix
  ];

}
