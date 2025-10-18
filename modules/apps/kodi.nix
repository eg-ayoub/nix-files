{ lib, inputs, pkgs, config, ... }: 

let
  cfg = config.apps.kodi;
in
{
  options.apps.kodi = {
    enable = lib.mkEnableOption "enable KODI Media Player";
  };

  config = lib.mkIf cfg.enable {
    programs.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [jellycon]);
    };
  };
}
