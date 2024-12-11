#!/bin/bash

$HYPR_CONFIG/scripts/configure-monitors.sh

hyprctl reload
pypr reload
pgrep ags && (ags -q && ags)
hyprctl notify 5 10000 0 'Hard reloaded Hyprland'
