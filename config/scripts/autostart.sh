
#!/usr/bin/env bash

# ==========================================
# AUTOSTART
# ==========================================

# ==========================================
# Notification daemon
# ==========================================
pkill -x swaync 2>/dev/null || true
swaync &

# ==========================================
# System tray / PolicyKit authentication
# ==========================================
polkit-gnome &

# ==========================================
# Clipboard history watcher
# ==========================================
if command -v wl-paste >/dev/null 2>&1 && command -v cliphist >/dev/null 2>&1; then
    wl-paste --watch cliphist store &
fi

if command -v wl-clip-persist >/dev/null 2>&1; then
    wl-clip-persist --clipboard regular --reconnect-tries 0 &
fi

# ==========================================
# D-Bus / systemd environment for portals
# ==========================================
systemctl --user import-environment \
    DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

dbus-update-activation-environment --systemd \
    DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

systemctl --user start xdg-desktop-portal-wlr

# ==========================================
# GTK / GNOME Interface Preferences
# ==========================================
gnome_schema="org.gnome.desktop.interface"

if command -v gsettings >/dev/null 2>&1; then
    gsettings set "$gnome_schema" gtk-theme 'Adwaita'
    gsettings set "$gnome_schema" icon-theme 'Adwaita'
    gsettings set "$gnome_schema" cursor-theme 'Adwaita'
    gsettings set "$gnome_schema" font-name 'Adwaita Sans Regular 11'
    gsettings set "$gnome_schema" color-scheme 'prefer-dark'
fi
    ) &
fi

# ==========================================
# Autostart complete
# ==========================================
