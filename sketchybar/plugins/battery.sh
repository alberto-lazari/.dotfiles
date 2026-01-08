#!/bin/bash

percent="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
power="$(pmset -g batt | grep 'AC Power')"

[[ -n "$percent" ]] || exit 1

case "$percent" in
  9[0-9]|100) icon='' ;;
  [6-8][0-9]) icon='' ;;
  [3-5][0-9]) icon='' ;;
  [1-2][0-9]) icon='' ;;
  *) icon='' ;;
esac

[[ -z "$power" ]] || icon=''

# Only show when on battery or charging
[[ -z "$power" ]] || (( "$percent" < 80 )) || {
  sketchybar --set "$NAME" icon='' label=''
  exit 0
}

sketchybar --set "$NAME" icon="$icon" label="$percent%"
