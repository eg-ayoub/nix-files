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

  cont.calibre.enable = true;
  cont.calibre.listen.port = 8084;

  system.virt.enable = true;

  # set hostname
  networking = {
    hostName = "pup";
    useDHCP = false;
  };

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
      "20-enp1s0f0" = {
        matchConfig.Name = "enp1s0f0";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "30-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          DHCP = "no";
          Address = [ "192.168.1.45/24" ];
          Gateway = [ "192.168.1.254" ];
          DNS = [
            "127.0.0.1"
            "8.8.8.8"
          ];
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
