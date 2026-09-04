{
  flake.nixosModules.hostTony =
    { config, lib, ... }:
    {
      imports = [ ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/7ec44b82-56e2-4e4e-8398-b1f981879002";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/186C-2548";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      fileSystems."/home/ayoub/bigdrive" = {
        device = "/dev/disk/by-uuid/17796bf6-7ecd-4eb1-8ccf-1bec8cd1e8e0";
        fsType = "ext4";
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/ccbff54e-f718-4e77-8e98-ea1059b42c9d"; }
      ];

      networking.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
