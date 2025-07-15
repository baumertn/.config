#!/usr/bin/env fish

# Get the current color scheme
set current_scheme (gsettings get org.gnome.desktop.interface color-scheme)

# Remove the single quotes from the output
set current_scheme (string trim -c \' $current_scheme)

if test $current_scheme = "prefer-dark"
    echo "D"
else
    echo "L"
end
