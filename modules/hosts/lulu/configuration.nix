{ inputs, self, ... }:
{
  flake.nixosConfigurations.lulu = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # Ryzen 3 PRO 2200GE
      inputs.nixos-hardware.nixosModules.common-cpu-amd

      # ssd
      inputs.nixos-hardware.nixosModules.common-pc-ssd

      self.nixosModules.hostLulu
    ];
  };

  flake.nixosModules.hostLulu =
    { ... }:
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
        openssh
        searxng
        caddy
      ];

      hardware.enableRedistributableFirmware = true;

      networking.hostName = "lulu";

      system.stateVersion = "26.05";
    };
}
