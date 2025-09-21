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

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # non flake inputs
    auto-dark-nvim = {
      url = "github:f-person/auto-dark-mode.nvim";
      flake = false;
    };
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
      vm = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };

        modules = [
          ./hosts/vm/configuration.nix
        ];
      };
      # 2 - mouse : (laptop) Tiling WM + dev tools
      mouse = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };

        modules = [
          ./hosts/mouse/configuration.nix
          nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
        ];
      };
      # 3 - kitty : (laptop)  KDE + Gaming
      tom = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };

        modules = [
          ./hosts/tom/configuration.nix
          # no need for ddg
          nixos-hardware.nixosModules.lenovo-legion-16ach6h-hybrid
        ];
      };
      # 4 - tiger : (desktop) KDE + Gaming
      # 5 - pup : (server) HomeLab 
      pup = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };

        modules = [
          ./hosts/pup/configuration.nix
          # needed for amd gpu support
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
        ];
      };
    };
  };
}
