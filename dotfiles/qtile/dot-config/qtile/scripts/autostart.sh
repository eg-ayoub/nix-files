#!/bin/sh

export XDG_CURRENT_DESKTOP="qtile"
export XDG_SESSION_TYPE="wayland"

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
dbus-update-activation-environment --sytemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

systemctl --user restart xdg-desktop-portal

# Start kanshi to manage displays
kanshi &
nm-applet &
