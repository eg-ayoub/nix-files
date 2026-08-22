{ inputs, self, ... }:
{
  flake.nixosConfigurations.tuffy = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      self.nixosModules.hostTuffy
    ];
  };

  flake.nixosModules.hostTuffy =
    { config, lib, pkgs, ... }:
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

      # lifted verbatim from
      # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/tiger-lake/default.nix
      boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "i915") [ "i915.enable_guc=3" ];
      hardware.intelgpu.vaapiDriver = "intel-media-driver";
    };
}
