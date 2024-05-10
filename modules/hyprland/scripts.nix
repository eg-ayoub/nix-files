{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.hyprland.hyprland;

  notify_brightness = pkgs.writeShellScriptBin "notify_brightness" ''
   bri="$(( $(brightnessctl g) * 100 / $(brightnessctl m) ))"
   notify-send "Brightness: $bri%" -h int:value:$bri -h string:synchronous:brightness
  '';
in
{
  options.hyprland.scripts = {};

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;[
      notify_brightness
    ];
  };

}
