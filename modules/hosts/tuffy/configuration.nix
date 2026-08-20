{ inputs, self, ... }:
{
  flake.nixosConfigurations.tuffy = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
      self.nixosModules.hostTuffy
    ];
  };

  flake.nixosModules.hostTuffy =
    { pkgs, ... }:
    {

      imports = with self.nixosModules; [
        systemd-boot
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
        wine
        terminal-toolbox
        zellij

        # virt
        containers
        libvirt

        # dev
        nvim
        language-servers

        # term
        starship-zsh

        # desktop
        niri-de
        pywal

        # apps
        godot
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
        zen-browser
        gimp

        # services
        tailscale
        openssh
      ];

      hardware.enableAllFirmware = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "tuffy";

      system.stateVersion = "26.05";
    };
}
