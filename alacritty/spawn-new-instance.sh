#!/bin/bash -e
# From: https://github.com/alacritty/alacritty/issues/808
alacritty_pid=$(osascript -e 'tell application "System Events" to get unix id of first application process whose name is "Alacritty" and frontmost = true')
shell_pid=$(pgrep -P $alacritty_pid -a zsh)
cwd=$(lsof -a -d cwd -p $shell_pid -F n | cut -c 2- | tail -n1)
# Run Alacritty
open -na Alacritty --args --working-directory=$cwd
