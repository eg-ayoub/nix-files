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
  boot.initrd.luks.devices."luks-a4902d23-9f67-4052-8212-315152738a9b".device = "/dev/disk/by-uuid/a4902d23-9f67-4052-8212-315152738a9b";

  system.gpu.intel.enable = true;
  system.gpu.nvidia.enable = true;
  system.gpu.nvidia.profile = 
    let 
      nvpkgs = config.boot.kernelPackages.nvidiaPackages;
      mouseCfg = import ./../../modules/system/gpu/nvidia/profiles/mouse.nix { inherit nvpkgs; } ;
    in
      mouseCfg;

  system.packages.plasma6.enable = true;
  # system.packages.hyprland.enable = true;

  networking.hostName = "mouse";
}
