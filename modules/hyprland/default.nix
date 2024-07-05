{ inputs, pkgs, config, ... }: {

  imports = [
    ./compositor.nix
    ./menu.nix
    ./bar.nix
    ./notif.nix
    ./clip.nix
    ./utils.nix
    ./scripts.nix
    ./kanshi.nix
    ./gtk.nix
  ];

}
