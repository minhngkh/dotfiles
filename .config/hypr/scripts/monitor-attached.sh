#!/bin/bash

cd $HYPR_CONFIG
echo "$(date): Monitor attached" >> monitor.log

num_monitors=$(hyprctl monitors all -j | jq 'length')

if [[ $num_monitors -lt 1 ]]; then
  echo "$(date): Monitor attached - update" >> monitor.log
  ln -sf monitors/multi.conf monitors.conf
fi
 


