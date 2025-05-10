#!/usr/bin/env fish

# Get the current color scheme
set current_scheme (gsettings get org.gnome.desktop.interface color-scheme)

# Remove the single quotes from the output
set current_scheme (string trim -c \' $current_scheme)

if test $current_scheme = "prefer-dark"
    # Switch to light mode
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    swaymsg reload
    echo "Light"
else
    # Switch to dark mode
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    swaymsg reload
    echo "Dark"
end
