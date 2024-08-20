{ ... } : {
  env = [
    "HYPRCURSOR_THEME,rose-pine-hyprcursor"
    "HYPRCURSOR_SIZE,24"
  ];
  general = {
    gaps_in = 5;
    gaps_out = 5;
  };
  input = {
    kb_layout = "fr,us";
    kb_options = "grp:win_space_toggle";
    resolve_binds_by_sym = 1;
  };
  exec-once = [
    "waybar"
    "swaync"
    "nm-applet"
    "wl-paste --type text  --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
  ];
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$menu" = "rofi -show drun -show-icons";
  "$pass" = "ROFI_PASS_BACKEND=wtype rofi-pass";
  "$clip" = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
  "$scr" = "grimblast --notify copysave area";
  windowrule =
    [
      "float, ^(Rofi)$"
    ];
  bindr =
    [
      "CAPS, Caps_Lock, exec, swayosd-client --caps-lock"
    ];
  bind = 
    [
      "$mod, Return, exec, $terminal"
      "$mod, d, exec, $menu"
      "$mod, p, exec, $pass"
      "$mod, v, exec, $clip"
      "$mod SHIFT, q, killactive"
      "$mod, TAB, fullscreen, 1"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
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
