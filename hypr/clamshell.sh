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
    hyprctl keyword monitor $LAPTOP_OUTPUT,disable
else
    hyprctl keyword monitor $LAPTOP_OUTPUT,preferred,0x0,auto
fi
