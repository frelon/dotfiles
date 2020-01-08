#!/usr/bin/env bash

/usr/bin/logger -p CRIT blur

icon="$HOME/Pictures/icon.png"
tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 20% -scale 500% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
i3lock -u -i "$tmpbg"
rm "$tmpbg"
