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
        ssh
        polkit
        gpg
        auto-recovery

        # utils
        terminal-toolbox
        zellij

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
        auto-update
      ];

      # updates first and once a week moves flake.lock forward, so tyke only deploys a lock lulu
      # is healthy on
      core.auto-update = {
        dates = "03:30";
        update-lock = true;
      };

      hardware.enableRedistributableFirmware = true;

      networking.hostName = "lulu";

      system.stateVersion = "26.05";
    };
}
