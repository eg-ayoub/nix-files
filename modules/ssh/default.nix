{ lib, pkgs, config, inputs, ... }:
let
  cfg = config.ssh;
in
{

  options.ssh = {
    enable = lib.mkEnableOption "enable ssh configs";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      controlMaster = "yes";
      controlPath = "~/.ssh/sockets/%r@%h-%p";
    };
  };

}
