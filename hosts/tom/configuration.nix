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
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  system.systemd-boot.enable = true;

  hardware.nvidia.prime.amdgpuBusId = "PCI:6:0:0";
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  system.packages.plasma6.enable = true;
  system.packages.gaming.enable = true;
  # system.packages.hyprland.enable = true;
  system.legion.enable = true;

  system.virt.enable = true;
  system.wine.enable = true;

  system.fcitx.enable = true;

  networking.hostName = "tom";
}
