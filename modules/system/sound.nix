{ inputs, pkgs, config, ... }: {

  # according to https://github.com/theNizo/linux_rocksmith/tree/main/guides
  services.pipewire = {
    enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;
  users.users.ayoub.extraGroups = [ "audio" "rtkit" ];
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  environment.systemPackages = with pkgs; [
    qpwgraph
    pavucontrol
    unzip # needed for rocksmith patch-nixos.sh
    rtaudio
  ];
}
