{ config, inputs, modulesPath, ... }:

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
  # TODO: set device here
  # boot.initrd.luks.devices."luks-a4902d23-9f67-4052-8212-315152738a9b".device = "/dev/disk/by-uuid/a4902d23-9f67-4052-8212-315152738a9b";

  hardware.nvidia.prime.amdgpuBusId = "PCI:6:0:0";

  system.packages.plasma6.enable = true;
  system.packages.gaming.enable = true;
  # system.packages.hyprland.enable = true;
  system.legion.enable = true;

  system.virt.enable = true;
  system.wine.enable = true;

  system.fcitx.enable = true;

  networking.hostName = "tom";
}
