{ config, lib, pkgs, ... }:
let
  cfg = config.system.gpu.intel;
in
{

  options.system.gpu.intel = {
    enable = lib.mkEnableOption "enable intel gpu";    
  };

  config = lib.mkIf cfg.enable { 
    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };

    hardware.opengl.extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
  };

}
