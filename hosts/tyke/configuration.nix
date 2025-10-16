{ pkgs, config, inputs, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/system
    ./../../modules/svc
    ./../../modules/cont
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      ayoub = import ./home.nix;
    };
  };

  # boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.kernel.sysctl."kernel.softlock_panic" = "1";
  boot.kernel.sysctl."kernel.panic" = "60";

  system.systemd-boot.enable = true;

  system.ssh-server.enable = true;
  # system.ssh-server.passwordAuth = true;

  svc.jellyfin.enable = true;
  svc.calibre-web.enable = true;
  svc.adguardhome.enable = true;
  svc.dnsmasq.enable = true;

  cont.calibre.enable = true;
  cont.calibre.listen.port = 8084;
  cont.nginx-proxy-manager.enable = true;

  system.virt.enable = true;

  # set hostname
  networking = {
    hostName = "tyke";
    useDHCP = false;
  };

  # dont use resolved
  services.resolved.enable = false;
  # make a bridge interface
  systemd.network = {
    enable = true;
    wait-online.enable = true;
    netdevs = {
      "10-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };
    networks = {
      "20-enp2s0" = {
        matchConfig.Name = "enp2s0";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "30-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          DHCP = "ipv6";
          Address = [ "192.168.1.45/24" "fd00:1337:acab::45/64" ];
          Gateway = [ "192.168.1.254" "fe80::8a0f:a2ff:fedd:f345%br0" ];
          IPv6AcceptRA = true;
        };
        ipv6AcceptRAConfig.UseDNS = false;
        dhcpV6Config = {
          PrefixDelegationHint = "::/56";
          UseAddress = true;
          UseDNS = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
