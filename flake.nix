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
  };

  outputs = { nixpkgs, nixos-hardware, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    # machine profiles
    nixosConfigurations = {

      # 1 - vm : (temporary) vm used to test this config
      # deprecated

      # 2 - mouse : (laptop) Tiling WM + dev tools
      # deprecated

      # 3 - tom : (laptop)  KDE + Gaming
      tom = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./hosts/tom/configuration.nix
          # no need for ddg
          nixos-hardware.nixosModules.lenovo-legion-16ach6h-hybrid
        ];
      };

      # 4 - tony : (desktop) KDE + Gaming
      tony = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./hosts/tony/configuration.nix
          # ryzen 5 9600x
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          # 9070xt
          nixos-hardware.nixosModules.common-gpu-amd
          # ssd
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };

      # 5 - pup : (server) HomeLab -> soon deprecated
      pup = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./hosts/pup/configuration.nix
          # needed for amd gpu support
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          # ssd
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };

      # 6- tyke : (server) HomeLab replacement of pup
      tyke = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./hosts/tyke/configuration.nix
          # intel cpu i5 - 8500T
          "${nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"
          # ssd
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };

    };
  };
}
