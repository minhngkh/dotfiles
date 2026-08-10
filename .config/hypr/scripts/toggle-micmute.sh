#!/bin/bash

# Toggle mic mute
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

# Sync LED with mic mute state
if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
    echo 1 | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
else
    echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
fi
