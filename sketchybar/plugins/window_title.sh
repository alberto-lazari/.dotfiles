#!/bin/bash

window_info="$(yabai -m query --windows --window)"
window_title="$(jq -r .title <<< "$window_info")"
: ${INFO:=$(jq -r .app <<< "$window_info")}

case "$INFO" in
  Finder) icon='󰀶' ;;

  # Display current job in terminal
  Alacritty) icon=''; label="$window_title" ;;
  WezTerm) icon=''; label="$window_title" ;;

  # Display window title
  Safari)
    icon=''
    # Remove current profile
    window_title="$(sed 's/[^—]* — //' <<< $window_title)"
    label="$window_title"
    ;;
  Firefox) icon='󰈹'; label="$window_title" ;;

  'Windows App') icon='󰢹'; label='Remote Desktop' ;;
  'Microsoft Teams')
    icon='󰊻';
    # Remove useless pre/postfixes
    window_title="$(sed 's/Chat | //' <<< $window_title)"
    window_title="$(sed 's/ | Microsoft Teams//' <<< $window_title)"
    label="$window_title"
    ;;
esac

# Display current app name by default
: ${label:="$INFO"}

# A sane limit on the window title lenght
limit=125
(( "${#label}" < $limit )) ||
   label="$(cut -c 1-$limit <<< $label)…"

sketchybar \
  --animate circ 5 \
  --set "$NAME" icon="$icon" label="$label" \
