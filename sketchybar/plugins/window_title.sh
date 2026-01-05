#!/bin/bash

window_info="$(yabai -m query --windows --window)"
window_title="$(jq -r .title <<< "$window_info")"
: ${INFO:=$(jq -r .app <<< "$window_info")}

case "$INFO" in
  # Display current job in terminal
  Alacritty)
    icon=''
    label="$window_title"
    ;;
  Safari)
    icon=''
    # Remove current profile
    window_title="$(sed 's/[^—]* — //' <<< $window_title)"
    label="$window_title"
    ;;
  Firefox)
    icon='󰈹'
    label="$window_title"
    ;;
  WezTerm)
    icon=''
    label="$window_title"
    ;;
  Finder) icon='󰀶' ;;
esac

# Display current app name by default
: ${label:="$INFO"}

# A sane limit on the window title lenght
limit=125
(( "${#label}" < $limit )) ||
   label="$(echo $label | cut -c 1-$limit)…"

sketchybar --animate circ 2.5 --set "$NAME" icon="$icon" label="$label"
