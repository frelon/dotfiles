#!/bin/bash

FILE=/tmp/norrsken.jpg
FINAL=/tmp/norrsken.png
URL=https://images.hdqwalls.com/download/aurora-northern-lights-4k-hh-2560x1440.jpg
SIZE=2560x1440

if [ ! -f "$FILE" ]; then
    wget "$URL" -O "$FILE"
fi

SCREEN_RESOLUTION="$(xdpyinfo | grep dimensions | cut -d' ' -f7)"
BGCOLOR="000000"
convert "$FILE" -gravity Center -background $BGCOLOR -extent "$SCREEN_RESOLUTION" RGB:- | i3lock --raw "$SCREEN_RESOLUTION":rgb -c $BGCOLOR -i /dev/stdin

