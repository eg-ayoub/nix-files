{ inputs, pkgs, config, ... }: {

  imports = [
    ./calibre-docker.nix
    ./home-assistant.nix
  ];

}
