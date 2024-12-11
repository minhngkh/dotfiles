#!/bin/bash

if [ $(hyprctl workspaces -j | jq 'any(.[]; .name == "special:music")') = false ]; then
  spotify
else 
  hyprctl dispatch togglespecialworkspace music
fi