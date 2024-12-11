#!/bin/bash

mode=$(hyprctl getoption input:follow_mouse -j | jq '.int')

if [[ $mode -ne 1 ]]; then
  hyprctl --batch 'keyword input:follow_mouse 1; keyword input:float_switch_override_focus 1'
else
  hyprctl --batch 'keyword input:follow_mouse 2; keyword input:float_switch_override_focus 0'
fi