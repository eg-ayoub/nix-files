{ inputs, self, ... }:
{
  flake.nixosConfigurations.tony = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # ryzen 5 9600x
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
      # 9070xt
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      # ssd
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      self.nixosModules.hostTony
    ];
  };

  flake.nixosModules.hostTony =
    { pkgs, ... }:
    {

      imports = with self.nixosModules; [
        systemd-boot
        networking
        audio
        locale
        ayoub-user
        nix
        zsh
        ssh
        clamav
        polkit
        gpg

        # utils
        wine
        terminal-toolbox

        # virt
        containers
        libvirt

        # dev
        nvim
        language-servers

        # term
        starship-zsh

        # desktop
        plasma6

        # apps
        godot
        virt-manager
        vial
        nsusb
        kitty
        jellyfin-desktop
        obs
        vlc
        discord
        element
        chromium
        steam
        deluge
        vpn
        rpcs3
        lutris
        zen-browser
      ];

      hardware.enableAllFirmware = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "tony";

      system.stateVersion = "23.11";
    };
}
