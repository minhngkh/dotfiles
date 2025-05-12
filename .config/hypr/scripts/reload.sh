#!/bin/bash

$HYPR_CONFIG/scripts/configure-monitors.sh

hyprctl reload
pypr reload
(pgrep hyprpanel && (hyprpanel -q)) || hyprpanel
hyprctl notify 5 10000 0 'Hard reloaded Hyprland'
