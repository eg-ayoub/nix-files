{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.kitty;
in
{
  options.kitty = {
    enable = lib.mkEnableOption "enable kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      font.name = "Inconsolata Nerd Font";
      extraConfig = ''
        enable_audio_bell no
        # remove mouse actions
        # clear_all_mouse_actions yes
        mouse_map left click ungrabbed
      '';
    };
    home.file = {

      "${config.xdg.configHome}/kitty/dark-theme.auto.conf" = {
        text = ''
          include ${pkgs.kitty-themes}/share/kitty-themes/themes/adwaita_dark.conf
          '';
      };

      "${config.xdg.configHome}/kitty/light-theme.auto.conf" = {
        text = ''
          include ${pkgs.kitty-themes}/share/kitty-themes/themes/adwaita_light.conf
          '';
      };

    };
  };

}
