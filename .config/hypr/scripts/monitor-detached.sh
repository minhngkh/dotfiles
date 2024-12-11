#!/bin/bash

cd $HYPR_CONFIG
echo "$(date): Monitor detached" >> monitor.log

num_monitors=$(hyprctl monitors all -j | jq 'length')

if [[ $num_monitors -eq 1 ]]; then
  echo "$(date): Monitor detached - update" >> monitor.log
  hyprctl keyword monitor eDP-1,enable
  ln -sf monitors/default.conf monitors.conf
fi
 

