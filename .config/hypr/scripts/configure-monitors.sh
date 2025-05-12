#!/bin/bash

num_monitors=$(hyprctl monitors all -j | jq 'length')

echo -n "$(date): Monitor configured" >> monitor.log

if [[ $num_monitors -le 1 ]]; then
  ln -sf $HYPR_CONFIG/monitors/default.conf $HYPR_CONFIG/monitors.conf
  echo " - default"
else
  ln -sf $HYPR_CONFIG/monitors/multi.conf $HYPR_CONFIG/monitors.conf
  echo " - multi"
fi
