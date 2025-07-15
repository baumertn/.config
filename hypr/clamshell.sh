#!/bin/bash

LAPTOP_OUTPUT="eDP-1"  # laptop display
EXTERNAL_OUTPUT="DP-2" # external monitor
LID_STATE_FILE="/proc/acpi/button/lid/LID/state"

# Read the lid state
# state: closed
read -r LS < "$LID_STATE_FILE"

# Strip prefix

# Check if external monitor is connected
if hyprctl monitors | grep -q "$EXTERNAL_OUTPUT"; then
    if grep -q "closed" "$LID_STATE_FILE"; then
        # If lid is closed
        hyprctl keyword monitor $LAPTOP_OUTPUT,disable
    else
        # If lid is open, reload Hyprland to enable eDP-1 and set monitor configurations
        hyprctl reload
    fi
else
    hyprctl reload
fi
