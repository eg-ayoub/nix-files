{ inputs, modulesPath, ... }:

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

  system.systemd-boot.enable = true;

  # system.grub-boot.enable = true;
  # system.grub-boot.boot-device = "/dev/vda";
  
  system.packages.plasma6.enable = true;

  networking.hostName = "mouse";
}
