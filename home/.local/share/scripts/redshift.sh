#!/bin/sh

UNIT="redshift"
STATE_FILE="/tmp/redshift-temp"
DEFAULT_TEMP=4500
MIN_TEMP=3000
MAX_TEMP=6500
STEP=250

# Efficient status check
is_running() {
  systemctl --user is-active --quiet "$UNIT"
}

get_temp() {
  [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo "$DEFAULT_TEMP"
}

set_temp() {
  echo "$1" > "$STATE_FILE"
  redshift -P -O "$1" >/dev/null 2>&1 &
}

toggle() {
  if is_running; then
    systemctl --user stop "$UNIT"
  else
    systemctl --user start "$UNIT"
  fi
}

adjust_temp() {
  cur=$(get_temp)
  case "$1" in
    up) new=$((cur + STEP)) ;;
    down) new=$((cur - STEP)) ;;
    *) exit 1 ;;
  esac

  # clamp
  [ "$new" -gt "$MAX_TEMP" ] && new=$MAX_TEMP
  [ "$new" -lt "$MIN_TEMP" ] && new=$MIN_TEMP

  set_temp "$new"
}

case "$1" in
  toggle) toggle ;;
  temperature)
    is_running && echo "$(get_temp)K" || echo "off"
    ;;
  up) is_running && adjust_temp up ;;
  down) is_running && adjust_temp down ;;
  *) echo "Usage: $0 [temperature|toggle|up|down]" ;;
esac

