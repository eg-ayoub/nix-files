{
  description = "My NixOS configurations";
  # https://github.com/eg-ayoub/nix-files

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # rocksmith patch
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, ... }@inputs:
  {
    # machine profiles
    nixosConfigurations = {

      # 1 - vm : (temporary) vm used to test this config
      # deprecated

      # 2 - mouse : (laptop) Tiling WM + dev tools
      # deprecated

      # 3 - tom : (laptop)  KDE + Gaming
      # deprecated
      # tom = nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./hosts/tom/configuration.nix
      #     # no need for ddg
      #     nixos-hardware.nixosModules.lenovo-legion-16ach6h-hybrid
      #     { nixpkgs.hostPlatform = "x86_64-linux"; }
      #   ];
      # };

      # 4 - tony : (desktop) KDE + Gaming
      tony = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nixos-rocksmith.nixosModules.default
          ./hosts/tony/configuration.nix
          # ryzen 5 9600x
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          # 9070xt
          nixos-hardware.nixosModules.common-gpu-amd
          # ssd
          nixos-hardware.nixosModules.common-pc-ssd
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ];
      };

      # 5 - pup : (server) HomeLab -> soon deprecated
      # deprecated

      # 6- tyke : (server) HomeLab replacement of pup
      tyke = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # this needs to be here because of the way I wrote packages.nix, which is very stupid
          # must fix it later
          inputs.nixos-rocksmith.nixosModules.default
          ./hosts/tyke/configuration.nix
          # intel cpu i5 - 8500T
          "${nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"
          # ssd
          nixos-hardware.nixosModules.common-pc-ssd
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ];
      };

    };
  };
}
