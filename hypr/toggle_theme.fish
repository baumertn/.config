#!/usr/bin/env fish

set theme_file ~/.config/theme_mode
set GTK3_FILE ~/.config/gtk-3.0/settings.ini
set GTK4_FILE ~/.config/gtk-4.0/settings.ini
set QT5CT_FILE ~/.config/qt5ct/qt5ct.conf
set QT6CT_FILE ~/.config/qt6ct/qt6ct.conf

# Get the current color scheme
set current_scheme (gsettings get org.gnome.desktop.interface color-scheme | string trim -c \')

if test "$current_scheme" = "prefer-dark"
    # Light Mode
    echo "light" > $theme_file

    gsettings set org.gnome.desktop.interface gtk-theme 'Breeze'
    gsettings set org.gnome.desktop.interface icon-theme 'Breeze'
    gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'
    gsettings set org.gnome.desktop.interface color-scheme 'default'

    # GTK config
    for f in $GTK3_FILE $GTK4_FILE
        mkdir -p (dirname $f)
        echo "[Settings]" > $f
        echo "gtk-theme-name=Breeze" >> $f
        echo "gtk-icon-theme-name=Breeze" >> $f
        echo "gtk-cursor-theme-name=Breeze" >> $f
        echo "gtk-font-name=Noto Sans 10" >> $f
    end

    # Qt5ct
    if test -f $QT5CT_FILE
        sed -i 's/style=.*/style=Breeze/' $QT5CT_FILE
    end

    # Qt6ct
    if test -f $QT6CT_FILE
        sed -i 's/style=.*/style=Breeze/' $QT6CT_FILE
    end

    echo "Switched to Light"
else
    # Dark Mode
    echo "dark" > $theme_file
    gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Breeze'
    gsettings set org.gnome.desktop.interface cursor-theme 'Breeze'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    # GTK config
    for f in $GTK3_FILE $GTK4_FILE
        mkdir -p (dirname $f)
        echo "[Settings]" > $f
        echo "gtk-theme-name=Breeze-dark" >> $f
        echo "gtk-icon-theme-name=Breeze" >> $f
        echo "gtk-cursor-theme-name=Breeze" >> $f
        echo "gtk-font-name=Noto Sans 10" >> $f
    end

    # Qt5ct
    if test -f $QT5CT_FILE
        sed -i 's/style=.*/style=Breeze/' $QT5CT_FILE
    end

    # Qt6ct
    if test -f $QT6CT_FILE
        sed -i 's/style=.*/style=Breeze/' $QT6CT_FILE
    end

    echo "Switched to Dark"
end

# # Reload Hyprland (if needed for cursors and apps)
# hyprctl reload
