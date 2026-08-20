{
  flake.nixosModules.hostTuffy =
    { config, lib, ... }:
    {
      imports = [];
    
      boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];
    
      fileSystems."/" =
        { device = "/dev/disk/by-uuid/04f74d62-0b90-4140-81d5-1a1ce99443b5";
          fsType = "btrfs";
        };
    
      fileSystems."/home" =
        { device = "/dev/disk/by-uuid/04f74d62-0b90-4140-81d5-1a1ce99443b5";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };
    
      fileSystems."/nix" =
        { device = "/dev/disk/by-uuid/04f74d62-0b90-4140-81d5-1a1ce99443b5";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };
    
      fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/6885-901F";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };
    
      swapDevices =
        [ { device = "/dev/disk/by-uuid/e890eba7-86ad-49e3-af38-061afb6e624f"; }
        ];
    
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
