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
  # cont.homeassistant.enable = true;

  system.virt.enable = true;

  # configure pup with a static ip address for adguardhome
  networking = {
    hostName = "pup";
    useDHCP = false;
    interfaces.enp1s0f0 = {
      useDHCP = false;
      ipv4.addresses = [
      {
        address = "192.168.1.45";
        prefixLength = 24;
      }
      ];
    };
    defaultGateway = "192.168.1.254";
    nameservers = [
      "8.8.8.8"
        "1.1.1.1"
    ];
  };
}
