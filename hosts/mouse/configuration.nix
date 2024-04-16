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
  boot.initrd.luks.devices."luks-a4902d23-9f67-4052-8212-315152738a9b".device = "/dev/disk/by-uuid/a4902d23-9f67-4052-8212-315152738a9b";

  system.packages.plasma6.enable = true;

  networking.hostName = "mouse";
}
