#!/bin/bash

# Toggle mute
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Sync LED with mute state
if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
    echo 1 | sudo tee /sys/class/leds/platform::mute/brightness > /dev/null
else
    echo 0 | sudo tee /sys/class/leds/platform::mute/brightness > /dev/null
fi
