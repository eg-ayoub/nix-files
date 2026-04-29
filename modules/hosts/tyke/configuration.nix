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
        clamav
        polkit
        gpg

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
        # calibre-web # CALIBRE-WEB is broken
        # calibre-docker
        invidious
        invidious-companion
        jellyfin
        openssh
        yattee-server

        # temp: install godot for remote work
        godot

      ];

      svc.adguardhome.dns.hosts = [
        "100.107.41.45"
        "fd7a:115c:a1e0::3b01:2985"
      ];
      # svc.calibre-docker.https-port = 8184;
      svc.invidious.domain = "tyke";
      svc.openssh.password-auth = true;

      hardware.enableAllFirmware = true;

      boot.kernel.sysctl."kernel.softlock_panic" = "1";
      boot.kernel.sysctl."kernel.panic" = "60";

      networking.hostName = "tyke";

      system.stateVersion = "23.11";

      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
    };
}
