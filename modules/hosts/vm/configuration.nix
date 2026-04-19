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
      ];

      core.boot.grub-boot.boot-device = "/dev/vda";

      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Paris";

      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
      };

      services.xserver.enable = true;

      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.xfce.enable = true;

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      services.printing.enable = true;

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

      };

      users.users.ayoub = {
        isNormalUser = true;
        description = "ayoub nasr";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [
          thunderbird
        ];
      };
      programs.firefox.enable = true;

      nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = with pkgs; [
        vim
        wget
        virtiofsd
      ];

      system.stateVersion = "25.11";

      networking.hostName = "vm";
    };
}
