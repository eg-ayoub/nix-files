{ pkgs, config, inputs, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/system
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      ayoub = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  system.systemd-boot.enable = true;

  system.packages.plasma6.enable = true;
  system.packages.gaming.enable = true;
  system.networkmanager.enable = true;

  system.virt.enable = true;
  system.vial.enable = true;
  system.wine.enable = true;
  system.ns-usbloader.enable = true;
  system.razer.enable = true;

  networking.hostName = "tony";
}
