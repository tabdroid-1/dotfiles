#!/bin/sh

killall hyprpaper && hyprpaper 
killall waybar && waybar
# $HOME/.config/hypr/scripts/randwall.sh

killall kdeconnectd
/usr/lib/kdeconnectd
kdeconnect-cli --refresh
kdeconnect-cli -l
