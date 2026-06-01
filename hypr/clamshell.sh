#!/bin/bash

LAPTOP_OUTPUT="eDP-1"  # laptop display
# LID_STATE_FILE="/proc/acpi/button/lid/LID/state"
#
# # Read the lid state
# # state: closed
# read -r LS < "$LID_STATE_FILE"
# if grep -q "closed" "$LID_STATE_FILE"; then
#     hyprctl keyword monitor $LAPTOP_OUTPUT,disable
# else
#     hyprctl reload
# fi

if hyprctl monitors -j | jq -e ".[] | select(.name == \"$LAPTOP_OUTPUT\")"; then
    hyprctl dispatch "hl.monitor.({ output = \"$LAPTOP_OUTPUT\", disabled = true })"
    # hyprctl keyword monitor $LAPTOP_OUTPUT,disable
else
    hyprctl dispatch "hl.monitor.({ output = 'eDP-1', mode = 'preffered', position = '0x0', scale = 'auto', })"
    # hyprctl keyword monitor $LAPTOP_OUTPUT,preferred,0x0,auto
fi
