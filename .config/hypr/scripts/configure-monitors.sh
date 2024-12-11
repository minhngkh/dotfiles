#!/bin/bash

num_monitors=$(hyprctl monitors all -j | jq 'length')

if [[ $num_monitors -eq 1 ]]; then
  ln -sf $HYPR_CONFIG/monitors/default.conf $HYPR_CONFIG/monitors.conf
else
  ln -sf $HYPR_CONFIG/monitors/multi.conf $HYPR_CONFIG/monitors.conf
fi
