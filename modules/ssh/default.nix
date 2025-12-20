{ lib, pkgs, config, inputs, ... }:
let
  cfg = config.ssh;
in
{

  options.ssh = {
    enable = lib.mkEnableOption "enable ssh configs";
    server.enable = lib.mkEnableOption "enable ssh server";
    server.passwordAuth = lib.mkEnableOption "enable ssh server password auth";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        controlMaster = "yes";
        controlPath = "~/.ssh/sockets/%r@%h-%p";
      };
    };
  };

}
