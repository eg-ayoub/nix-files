{ inputs, self, ... }:
{
  flake.nixosConfigurations.tuffy = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
      # T14 Intel Gen 2: a Tiger Lake cpu and its gpu; nixos-hardware exports no module for it
      "${inputs.nixos-hardware}/common/cpu/intel/tiger-lake"
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
        ssh
        polkit
        gpg

        # utils
        wine
        terminal-toolbox
        zellij

        # virt
        containers

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
      ];

      app.discord.itf = "wlp0s20f3";
      hardware.enableAllFirmware = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "tuffy";

      system.stateVersion = "26.05";
    };
}
