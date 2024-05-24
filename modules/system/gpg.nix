{ inputs, pkgs, config, ... } : {

  services.udev.packages = [ pkgs.yubikey-personalization ];

  hardware.gpgSmartcards.enable = true;

  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
