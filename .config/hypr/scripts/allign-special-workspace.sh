#!/bin/bash

term_workspace="special:term"

active_window=$(hyprctl activewindow -j)

workspace=$(echo "$active_window" | jq -r '.workspace.name')
if [ "$workspace" != "$term_workspace" ]; then
  hyprctl notify 3 5000 0 'Current window is not in special workspace'
  exit 1
fi

# Get all windows in the target special workspace
raw=$(hyprctl clients -j | jq -c --arg WORKSPACE "$term_workspace" '.[] | select(.workspace.name == $WORKSPACE)')
readarray -t array <<< "$raw"

echo "$array"

for window in "$windows"; do
  echo "$window"
  exit 1
  # address=$(echo "$window" | jq -r '.address')
  # echo -n "$address"
  # echo -n "address:\"$address\""
  # hyprctl dispatch setfloating "address:\"$address\""
done

# Get all window addresses in the target special workspace
# The 'active_window' variable is from the top of the script and confirmed to be in term_workspace
# The 'term_workspace' variable is also defined at the top.

# window_addresses=$(echo "$windows" | jq -r '.address')
# for address in "$window_addresses"; do
#   echo "$address"
# done

# num_windows=$(echo "$window_addresses_json" | jq 'length')

# if [ "$num_windows" -eq 1 ]; then
#   # No windows to arrange, or they disappeared.
#   exit 0
# fi

# # Get the monitor ID from the active window, which is known to be in the special workspace
# monitor_id=$(echo "$active_window" | jq '.monitor')

# # Get the geometry of that monitor
# monitor_info=$(hyprctl -j monitors | jq --argjson ID "$monitor_id" '.[] | select(.id == $ID)')

# if [ -z "$monitor_info" ] || [ "$(echo "$monitor_info" | jq -r '.id // "null"')" == "null" ]; then
#   hyprctl notify 3 5000 0 "Error: Could not find monitor $monitor_id details."
#   # Fallback to focused monitor if active window's monitor somehow not found
#   monitor_info=$(hyprctl -j monitors | jq '.[] | select(.focused == true)')
#   if [ -z "$monitor_info" ] || [ "$(echo "$monitor_info" | jq -r '.id // "null"')" == "null" ]; then
#     # Final fallback to the first monitor
#     monitor_info=$(hyprctl -j monitors | jq '.[0]')
#   fi
#   if [ -z "$monitor_info" ] || [ "$(echo "$monitor_info" | jq -r '.id // "null"')" == "null" ]; then
#     hyprctl notify 3 5000 0 'Error: Could not determine monitor for arrangement.'
#     exit 1
#   fi
# fi

# mon_x=$(echo "$monitor_info" | jq '.x')
# mon_y=$(echo "$monitor_info" | jq '.y')
# mon_width=$(echo "$monitor_info" | jq '.width')
# mon_height=$(echo "$monitor_info" | jq '.height')

# # Calculate size for each window (simple horizontal tiling)
# # Ensure division by num_windows is safe (num_windows > 0 checked above)
# win_width=$((mon_width / num_windows))
# win_height=$mon_height # Each window takes full monitor height

# # Iterate through windows and arrange them
# for i in $(seq 0 $((num_windows - 1))); do
#   address=$(echo "$window_addresses_json" | jq -r ".[$i]")
  
#   current_x=$((mon_x + i * win_width))
#   current_y=$mon_y
  
#   # Resize the window first
#   hyprctl dispatch resizewindowpixel "exact $win_width $win_height,address:$address"
#   # Then move the window to its calculated position
#   hyprctl dispatch movewindowpixel "exact $current_x $current_y,address:$address"
# done

# hyprctl notify 1 3000 "rgb(88aaee)" "Arranged $num_windows window(s) in $term_workspace"