#!/bin/bash

data=$(hyprctl clients -j | jq -r '.[] | select(.class | test("^(com.chatterino.chatterino)$")) | {size, at, workspace}')
if [ -z "$data" ]; then
  hyprctl notify 3 5000 0 'Chatterino not found'
  exit 1
fi

workspace=$(echo "$data" | jq '.workspace.id')
cur_workspace=$(hyprctl activeworkspace -j | jq '.id')
if [ "$workspace" != "$cur_workspace" ]; then
  hyprctl notify 3 5000 0 'Chatterino is not in active workspace'
  exit 1
fi

if [ "$(echo "$data" | jq '.size | length')" -ne 2 ]; then
  hyprctl notify 3 5000 0 'Chatterino size not found'
  exit 1
fi

is_floating=$(hyprctl activewindow -j | jq '.floating')
if [ "$is_floating" = false ]; then
  hyprctl notify 3 5000 0 'Current window is not floating'
  exit 1
fi

size=($(echo "$data" | jq -r '.size | @sh'))
pos=($(echo "$data" | jq -r '.at | @sh'))
cur_size=($(hyprctl activewindow -j | jq -r '.size | @sh'))

# new_height=($(echo "${size[0]} / ${cur_size[0]} * ${cur_size[1]}" | bc -l))
new_height=$(awk "BEGIN {print int(${size[0]} / ${cur_size[0]} * ${cur_size[1]})}")

hyprctl dispatch resizeactive exact ${size[0]} $new_height
hyprctl dispatch moveactive exact ${pos[@]}