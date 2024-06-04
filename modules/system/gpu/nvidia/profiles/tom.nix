{ nvpkgs, ... } : {
  modesetting.enable = true;
  # can cause issues
  powerManagement = {
    enable = false;
    finegrained = false;
  };
  open = false;
  nvidiaSettings = true;
  package = nvpkgs.stable;
  prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
