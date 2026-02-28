{ inputs, pkgs, config, ... }: {

  imports = [
    ./adguardhome.nix
    ./calibre-web.nix
    ./dnsmasq.nix
    ./invidious.nix
    ./jellyfin.nix
    ./tailscale.nix
  ];

}
