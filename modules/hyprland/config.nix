{
  input = {
    kb_layout = "fr,us";
    kb_options = "grp:win_space_toggle";
  };
  monitor = [
    "eDP-1, preferred, auto-left, auto"
    "DP-1,  preferred, auto, auto"
  ];
  #workspace = [
  #  "r[1-10],"
  #];
  exec-once = [
    "waybar"
    "swaync"
    "nm-applet"
  ];
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$menu" = "fuzzel";
  bind = 
    [
      "$mod, Return, exec, $terminal"
      "$mod, d, exec, $menu"
      "$mod SHIFT, q, killactive"
      "$mod, TAB, fullscreen, 1"
      ", XF86MonBrightnessDown, exec, brightnessctl s 5%- -n 6000"
      ", XF86MonBrightnessDown, exec, notify_brightness"
      ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
      ", XF86MonBrightnessUp, exec, notify_brightness"
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
