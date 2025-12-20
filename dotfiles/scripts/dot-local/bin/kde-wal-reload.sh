#!/bin/bash

set -e

log() {
    echo "[wal-reload] $1"
}

cleanup() {
    log "Running exit hook: wal -n --theme solarized"
    wal -n --theme solarized
}
trap cleanup EXIT

log "Fetching current wallpaper path..."
WALLPAPER=$(timeout 5s qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.wallpaper 0 | grep 'Image: file:' | sed -E 's|Image: file://||') || { log "Failed to fetch wallpaper path"; exit 1; }
log "Wallpaper: $WALLPAPER"

log "Determining color scheme mode..."
if [ $# -gt 0 ] && [[ "$1" == @(light|dark) ]]; then
    MODE="$1"
else
    MODE_NUM=$(timeout 5s qdbus org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read "org.freedesktop.appearance" "color-scheme" | sed -E 's/^[^ ]+ //') || { log "Failed to fetch color scheme mode"; exit 1; }
    if [ "$MODE_NUM" -eq 1 ]; then
        MODE="dark"
    elif [ "$MODE_NUM" -eq 2 ]; then
        MODE="light"
    else
        MODE="unknown"
    fi
fi
log "Mode: $MODE"

log "Generating new color scheme using wal..."
if [ "$MODE" = "light" ]; then
    timeout 10s wal -n -l -i "$WALLPAPER" || { log "wal failed"; exit 1; }
else
    timeout 10s wal -n -i "$WALLPAPER" || { log "wal failed"; exit 1; }
fi
