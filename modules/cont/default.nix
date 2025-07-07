{ inputs, pkgs, config, ... }: {

  imports = [
    ./calibre-docker.nix
    ./nginx-proxy-manager.nix
  ];

}
