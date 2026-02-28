{ inputs, pkgs, config, ... }: {

  imports = [
    ./calibre-docker.nix
    ./invidious-companion.nix
    ./nginx-proxy-manager.nix
    ./yattee-server.nix
  ];

}
