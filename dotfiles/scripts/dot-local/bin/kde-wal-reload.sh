#!/bin/bash

log() {
    echo "[wal-reload] $1"
}

log "Fetching current wallpaper path..."
# Fetch current wallpaper path and clean up to get absolute path
WALLPAPER=$(qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.wallpaper 0 | grep 'Image: file:' | sed -E 's|Image: file://||')
log "Wallpaper: $WALLPAPER"

log "Fetching color scheme mode..."
# Fetch light/dark mode setting
MODE_NUM=$(qdbus org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read "org.freedesktop.appearance" "color-scheme" | sed -E 's/^[^ ]+ //')
if [ "$MODE_NUM" -eq 1 ]; then
    MODE="dark"
elif [ "$MODE_NUM" -eq 2 ]; then
    MODE="light"
else
    MODE="unknown"
fi
# overlwrite if arg 1 is given
# only if arg is light or dark
# only second expression uses [[ for pattern matching
if [ $# -gt 0 ] && [[ "$1" == @(light|dark) ]] ; then
    MODE="$1"
fi
log "Mode: $MODE"

log "Generating new color scheme using wal..."
if [ "$MODE" = "light" ]; then
    wal -n -l -i "$WALLPAPER"
else
    wal -n -i "$WALLPAPER"
fi
