#!/bin/bash

killall -q hyprpanel
killall -q dunst
killall -q waybar

sleep 1
hyprpanel &

