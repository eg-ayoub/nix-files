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
  system.ssh-server.passwordAuth = true;

  svc.jellyfin.enable = true;
  svc.calibre-web.enable = true;

  cont.calibre.enable = true;
  cont.calibre.listen.port = 8084;

  system.virt.enable = true;
  networking.hostName = "pup";
}
