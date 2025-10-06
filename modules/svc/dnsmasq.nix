{ pkgs, lib, config, ... }:
let
  cfg = config.svc.dnsmasq;
in
{
  options.svc.dnsmasq = {
    enable = lib.mkEnableOption "enable dnsmasq DHCP server";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [
      53 # DNS
      67 # DHCPv4 server
      68 # DHCPv4 client
      546 # DHCPv6 client
      547 # DHCPv6 server
    ];
    services.dnsmasq = {
      enable = true;
      alwaysKeepRunning = true;
      settings = {
        port = 0; # Disable DNS, handled by AdGuard Home
        # bind-interfaces = true;
        # interface = [ "br0" ];
        # except-interface = [ "lo" ];

        listen-address = [
          "192.168.1.45"
          "fd00:1337:acab::45"
        ];
        # DNS FORWARDING: All client queries hit Dnsmasq, which sends them to AdGuard Home.
        no-resolv = true;
        bogus-priv = true;
        server = [
          "127.0.0.1"
        ];

        # Local Network Configuration
        domain = "lan";
        expand-hosts = true;
        dhcp-authoritative = true; # Dnsmasq is the only DHCP server
        enable-ra = true; 

        log-dhcp = true;
        log-queries = true;

        # DHCP RANGE ARRAY (IPv4 + IPv6)
        dhcp-range = [ 
          "192.168.1.50,192.168.1.199,12h"
          "tag:lan,::100,::1ff,constructor:br0" 
        ]; 

        # DHCP OPTION ARRAY (Gateway + DNS v4 + DNS v6)
        dhcp-option = [
          "option:router,192.168.1.254"          # IPv4 Gateway (Bbox)
          "option:dns-server,192.168.1.45"       # IPv4 DNS (AdGuard Home)
          "option6:dns-server,[::]"              # IPv6 RDNSS (AdGuard Home GUA)
        ];
      };
    };
  };
}
