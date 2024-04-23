{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.shell.direnv;
in
{
  options.shell.direnv = {
    enable = lib.mkEnableOption "enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = lib.fileContents ./direnvrc;
    };
  };
}
