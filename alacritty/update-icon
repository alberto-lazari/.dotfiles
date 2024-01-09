#!/bin/bash -e
# From https://github.com/hmarr/dotfiles/blob/main/bin/update-alacritty-icon.sh

icon=/Applications/Alacritty.app/Contents/Resources/alacritty.icns
if [[ ! -f "$icon" ]]; then
  echo "Can't find existing icon, make sure Alacritty is installed" >&2
  exit 1
fi

if [[ ! -f "$icon.bak" ]]; then
    echo Backing up existing Alacritty icon
    hash="$(shasum "$icon" | head -c 10)"
    mv "$icon" "$icon.bak"
fi

# Variant of the original icon, without the orange shadow, adapted for macOS
icon_url='https://user-images.githubusercontent.com/517469/188788759-ce02e970-c349-44ef-9f53-c9af2dbb2178.png'

curl -sL "$icon_url" > "$icon"

touch /Applications/Alacritty.app
killall Dock
