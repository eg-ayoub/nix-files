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
  };

  outputs = { nixpkgs, ... }@inputs: 
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
        ];
      };
      # 3 - tiger : (desktop) KDE + Gaming
    };
  };
}
