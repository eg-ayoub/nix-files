{ inputs, pkgs, config, ... }: {

  imports = [
    ./jellyfin.nix
    ./calibre-web.nix
  ];

}
