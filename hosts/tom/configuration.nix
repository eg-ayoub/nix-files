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

  hardware.nvidia.prime.amdgpuBusId = "PCI:6:0:0";
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.181";
    sha256_64bit = "sha256-8G0lzj8YAupQetpLXcRrPCyLOFA9tvaPPvAWurjj3Pk=";
    sha256_aarch64 = "sha256-1pUDdSm45uIhg0HEhfhak9XT/IE/XUVbdtrcpabZ3KU=";
    openSha256 = "sha256-U/uqAhf83W/mns/7b2cU26B7JRMoBfQ3V6HiYEI5J48=";
    settingsSha256 = "sha256-iBx/X3c+1NSNmG+11xvGyvxYSMbVprijpzySFeQVBzs=";
    persistencedSha256 = "sha256-RoAcutBf5dTKdAfkxDPtMsktFVQt5uPIPtkAkboQwcQ=";
  };
  #  version = "575.64.05";
  #  sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
  #  sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
  #  openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
  #  settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
  #  persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";

  system.packages.plasma6.enable = true;
  system.packages.gaming.enable = true;
  system.legion.enable = true;
  system.networkmanager.enable = true;

  system.virt.enable = true;
  system.vial.enable = true;
  system.wine.enable = true;
  system.ns-usbloader.enable = true;

  #  system.fcitx.enable = true;

  networking.hostName = "tom";
}
