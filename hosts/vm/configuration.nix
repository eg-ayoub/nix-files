{ inputs, modulesPath, ... }:

{
  imports = [
    # (modulesPath + "/virtualisation/qemu-vm.nix")
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

  # virtualisation = {
  #   qemu.guestAgent.enable = true;
  #   qemu.options = [ "-display sdl,gl=on" "-vga virtio" ];
  # };

  networking.hostName = "vm";
}
