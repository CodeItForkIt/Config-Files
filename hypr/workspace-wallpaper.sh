#!/bin/bash

MONITOR="DP-2"
WALLPAPERS=(
  [1]="$HOME/Documents/Wallpapers/1080p/Way-of-Kings.jpg"
  [2]="$HOME/Documents/Wallpapers/1080p/Words-of-Radiance.jpg"
  [3]="$HOME/Documents/Wallpapers/1080p/Oathbringer.jpg"
  [4]="$HOME/Documents/Wallpapers/1080p/Rhythm-of-War.jpg"
  [5]="$HOME/Documents/Wallpapers/1080p/Wind-and-Truth.jpg"
)
FALLBACK="$HOME/Documents/Wallpapers/1080p/stormlight-archives-fallback.jpg"

set_wallpaper() {
  local wall="$1"
  noctalia msg wallpaper-set "$MONITOR" "$wall"
}

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

while true; do
  while [ ! -S "$SOCK" ]; do
    sleep 1
  done

  socat -u "UNIX-CONNECT:$SOCK" - | while read -r line; do
    case $line in
    workspace\>\>*)
      WS="${line#workspace>>}"
      if [[ -n "${WALLPAPERS[$WS]}" ]]; then
        set_wallpaper "${WALLPAPERS[$WS]}"
      elif [[ "$WS" -ge 6 ]]; then
        set_wallpaper "$FALLBACK"
      fi
      ;;
    esac
  done

  sleep 1
done
