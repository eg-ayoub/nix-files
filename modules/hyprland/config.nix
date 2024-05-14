{
  general = {
    gaps_in = 5;
    gaps_out = 5;
  };
  input = {
    kb_layout = "fr,us";
    kb_options = "grp:win_space_toggle";
    resolve_binds_by_sym = 1;
  };
  monitor = [
    "eDP-1, preferred, auto-right, auto"
    "DP-1,  preferred, auto, auto"
  ];
  exec-once = [
    "waybar"
    "swaync"
    "nm-applet"
  ];
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$menu" = "fuzzel";
  "$pass" = "tessen";
  "$clip" = "copyq show";
  "$scr" = "grimblast --notify copysave area";
  bind = 
    [
      "$mod, Return, exec, $terminal"
      "$mod, d, exec, $menu"
      "$mod, p, exec, $pass"
      "$mod, v, exec, $clip"
      "$mod SHIFT, q, killactive"
      "$mod, TAB, fullscreen, 1"
      ", XF86MonBrightnessDown, exec, brightnessctl s 5%- --min-value=240 -e"
      ", XF86MonBrightnessDown, exec, notify_brightness"
      ", XF86MonBrightnessUp, exec, brightnessctl s +5% -e"
      ", XF86MonBrightnessUp, exec, notify_brightness"
      ", Print, exec, $scr"
    ] ++ (
      builtins.concatLists (builtins.genList (
        x: let
            ws = builtins.toString (x + 1);
            code = builtins.toString (x + 10);
        in [
          "$mod, code:${code}, moveworkspacetomonitor, ${ws} current"
          "$mod, code:${code}, workspace, ${ws}"
          "$mod SHIFT, code:${code}, movetoworkspacesilent, ${ws}"
        ]
      )
      10)
    );
}
