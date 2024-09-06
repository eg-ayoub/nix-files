{ pkgs, config, inputs, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/system
    ./../../modules/svc
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

  boot.kernelPackages = pkgs.linuxPackages_6_1;

  system.systemd-boot.enable = true;

  system.ssh-server.enable = true;
  system.ssh-server.passwordAuth = true;

  svc.jellyfin.enable = true;
  svc.calibre-web.enable = true;

  system.virt.enable = true;
  networking.hostName = "pup";
}
