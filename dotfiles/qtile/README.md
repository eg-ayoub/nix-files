# Qtile config

# requirements (arch package names)
python3
qtile
lightdm lightdm-gtk-greeter
uwsm
python-pyxdg
network-manager-applet
gnome-keyring
xdg-desktop-portal
xdg-desktop-portal-wlr
xdg-desktop-portal-gtk
thunar
rofi-wayland
dunst
python-pywlroots
kanshi

# uwsm wayland session
in /usr/share/wayland-sessions/qtile-uwsm.desktop
```
[Desktop Entry]
Name=Qtile (UWSM)
Comment=Qtile session with UWSM
Exec=uwsm start qtile-wayland.desktop 
Type=Application
```


