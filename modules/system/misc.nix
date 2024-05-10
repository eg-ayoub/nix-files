{ ... }: {

  security.polkit.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11";
}
