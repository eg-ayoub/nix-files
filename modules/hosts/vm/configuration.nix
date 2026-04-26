{ inputs, self, ... }:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostVM
    ];
  };

  flake.nixosModules.hostVM =
    { ... }:
    {

      imports = with self.nixosModules; [
        grub-boot
        ayoub-user
        networking
        audio
        locale
        nix
        zsh
        ssh
        clamav
        polkit
        gpg

        # utils
        # wine
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
        xfce

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
        # steam
        deluge
        vpn
        rpcs3
        lutris
        zen-browser
      ];

      core.boot.grub-boot.boot-device = "/dev/vda";

      networking.hostName = "vm";

      system.stateVersion = "25.11";
    };
}
