{ inputs, self, ... }:
{
  flake.nixosConfigurations.tyke = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # intel cpu i5-8500T
      "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"

      # ssd
      inputs.nixos-hardware.nixosModules.common-pc-ssd

      self.nixosModules.hostTyke
    ];
  };

  flake.nixosModules.hostTyke =
    { pkgs, ... }:
    {

      imports = with self.nixosModules; [
        systemd-boot
        ayoub-user
        networking
        locale
        nix
        zsh
        ssh
        polkit
        gpg
        auto-recovery

        # utils
        terminal-toolbox
        zellij

        # virt
        containers

        # dev
        nvim
        language-servers

        # term
        starship-zsh

        # services
        tailscale
        adguardhome
        calibre-web
        calibre-docker
        invidious
        invidious-companion
        jellyfin
        openssh
        caddy
      ];

      svc.adguardhome.dns.hosts = [
        "100.107.41.45"
        "fd7a:115c:a1e0::3b01:2985"
      ];
      svc.calibre-web.kobo-lan.interface = "enp2s0";
      systemd.services.jellyfin.unitConfig.RequiresMountsFor = [ "/mnt/drive/Videos" ];

      hardware.enableAllFirmware = true;

      networking.hostName = "tyke";

      system.stateVersion = "23.11";

      # UHD 630 (Gen 9.5): VA-API through iHD, OpenCL through the legacy compute runtime
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime-legacy1
        ];
      };

      services.jellyfin.hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/renderD128";
      };
    };
}
