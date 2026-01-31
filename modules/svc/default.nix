{ inputs, pkgs, config, ... }: {

  imports = [
    ./adguardhome.nix
    ./calibre-web.nix
    ./dnsmasq.nix
    ./jellyfin.nix
    ./tailscale.nix
  ];

}
