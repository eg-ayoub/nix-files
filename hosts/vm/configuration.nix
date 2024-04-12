{ inputs, config, pkgs, ... }:

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
  };

  system.grub-boot.enable = true;
  system.grub-boot.boot-device = "/dev/vda";

  networking.hostName = "vm";
}
