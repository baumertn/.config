#!/usr/bin/env bash

# tofi power menu
choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | tofi --prompt "Power: ")

case "$choice" in
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        hyprlock & sleep 0.5; systemctl suspend
        # systemctl suspend-then-hibernate
        # systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
