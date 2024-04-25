{
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$menu" = "wofi --show drun";
  bind = 
    [
      "$mod, Return, exec, $terminal"
      "$mod, d, exec, $menu"
    ];
}
