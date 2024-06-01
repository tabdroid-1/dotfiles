#!/bin/bash

# Path to the directory containing wallpaper images
wallpaper_dir="$HOME/Pictures/walpapers"

# Get a random wallpaper from the directory
wallpaper=$(ls "$wallpaper_dir"/*.{jpg,png} | shuf -n 1)

# to save memory
killall swaybg

# Use swaybg to set the random wallpaper
# swww img "$wallpaper" --transition-type center --transition-step 1 --transition-fps 60
# swaybg -i "$wallpaper"

# idk if there is a way to not see that bitch in hyprland when loading random wallpaper

