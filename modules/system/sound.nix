{ inputs, pkgs, config, ... }: {
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
# according to https://github.com/theNizo/linux_rocksmith/tree/main/guides
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];
  users.users.ayoub.extraGroups = [ "audio" "rtkit" ];
  environment.systemPackages = with pkgs; [
    qpwgraph
    pavucontrol
    unzip # needed for rocksmith patch-nixos.sh
    rtaudio
  ];
}
