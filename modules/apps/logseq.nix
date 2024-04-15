{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.logseq;
in
{
  options.apps.logseq = {
    enable = lib.mkEnableOption "enable logseq";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      logseq
    ];
  };
}
