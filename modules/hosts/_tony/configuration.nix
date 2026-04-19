{ inputs, self, ... }:
{
  flake.nixosConfigurations.tony = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostTony
    ];
  };

  flake.nixosModules.hostTony =
    { pkgs, ... }:
    {

      imports = [
        # ryzen 5 9600x
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        # 9070xt
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        # ssd
        inputs.nixos-hardware.nixosModules.common-pc-ssd

        # rocksmith support with steam
        # inputs.nixos-rocksmith.nixosModules.default
      ];

      hardware.enableAllFirmware = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostname = "tony";
    };
}
