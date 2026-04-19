{ inputs, self, ... }:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostVM
    ];
  };

  flake.nixosModules.hostVM =
    { pkgs, ... }:
    {

      imports = [
        self.nixosModules.grub-boot
        self.nixosModules.networking
        self.nixosModules.locale
        self.nixosModules.ayoub-user
        self.nixosModules.nix
        self.nixosModules.audio
      ];

      core.boot.grub-boot.boot-device = "/dev/vda";

      networking.hostName = "vm";

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;
      services.pulseaudio.enable = false;

      programs.firefox.enable = true;
      environment.systemPackages = with pkgs; [
        vim
        wget
        virtiofsd
      ];

      system.stateVersion = "25.11";
    };
}
