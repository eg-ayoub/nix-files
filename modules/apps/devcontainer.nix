{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.devcontainer;
in
{
  options.apps.devcontainer = {
    enable = lib.mkEnableOption "enable devcontainer";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      devcontainer
    ];
  };
}
