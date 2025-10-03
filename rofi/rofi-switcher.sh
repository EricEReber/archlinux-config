#!/usr/bin/env bash
set -euo pipefail

ROFI=${ROFI:-rofi}
# Point this to your theme file:
THEME="${ROFI_THEME:-/home/eric/.config/rofi/themes/spotlight.rasi}"

# Only pass -theme if the file exists
theme_args=()
[ -f "$THEME" ] && theme_args=(-theme "$THEME")

MSG_BIN="swaymsg"

list_windows() {
  "$MSG_BIN" -t get_tree | jq -r '
    ..
    | objects
    | select(.type? == "con" and (.nodes|length==0) and (.floating_nodes|length==0))
    | [
        .id,
        (.app_id // .window_properties.class // "window"),
        (.name // "")
      ] | @tsv
  ' | awk -F'\t' '{printf("W\t%s\t  %s — %s\n",$1,$2,$3)}'
}

list_tabs() {
  if command -v bt >/dev/null 2>&1; then
    bt list | awk -F'\t' 'NF>=3 {printf("T\t%s\t  %s — %s\n",$1,$2,$3)}'
  fi
}

choice="$(
  { list_windows; list_tabs; } | ${ROFI} "${theme_args[@]}" -dmenu -i -p "Go to"
)" || exit 0

type="${choice%%$'\t'*}"
rest="${choice#*$'\t'}"
id="${rest%%$'\t'*}"

case "$type" in
  W) exec "$MSG_BIN" "[con_id=$id]" focus >/dev/null ;;
  T) bt activate "$id" || true; exec "$MSG_BIN" "[app_id=firefox]" focus >/dev/null ;;
esac
