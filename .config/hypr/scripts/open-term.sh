#!/bin/bash

if [ $(hyprctl workspaces -j | jq 'any(.[]; .name == "special:term")') = false ]; then
  hyprctl dispatch exec '[workspace special:term] kitty'
else 
  hyprctl dispatch togglespecialworkspace term
fi