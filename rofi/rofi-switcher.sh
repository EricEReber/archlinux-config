#!/usr/bin/env bash
set -euo pipefail

ROFI=${ROFI:-rofi}
THEME="${ROFI_THEME:-/home/eric/.config/rofi/themes/spotlight-dark.rasi}"

theme_args=()
[ -f "$THEME" ] && theme_args=(-theme "$THEME")

MSG_BIN="swaymsg"

list_windows() {
  "$MSG_BIN" -t get_tree | jq -r '
    ..
    | objects
    | select(.type? == "con" and (.nodes|length==0) and (.floating_nodes|length==0))
    | [ .id, (.app_id // .window_properties.class // "window"), (.name // "") ]
    | @tsv
  ' | awk -F'\t' '{printf("W\t%s\t\t\t  %s — %s\n",$1,$2,$3)}'
  # Fields: TYPE, CON_ID, _, _, LABEL
}

# Return firefox windows: con_id \t name
ff_windows() {
  "$MSG_BIN" -t get_tree | jq -r '
    ..
    | objects
    | select(
        .type? == "con"
        and (.nodes|length==0) and (.floating_nodes|length==0)
        and (
          (.app_id? // "") | test("(?i)^firefox")
          or (.window_properties.class? // "") | test("(?i)^firefox")
        )
      )
    | [ tostring, (.name // "") ] | @tsv
  '
}

# Mark every firefox window with a unique mark ("ffwin-<con_id>")
mark_ff_windows() {
  while IFS=$'\t' read -r cid _name; do
    [ -n "$cid" ] || continue
    "$MSG_BIN" "[con_id=$cid]" mark --add "ffwin-$cid" >/dev/null
  done < <(ff_windows)
}

# Unmark all firefox window marks created by this script
unmark_ff_windows() {
  while IFS=$'\t' read -r cid _name; do
    [ -n "$cid" ] || continue
    "$MSG_BIN" "[con_id=$cid]" unmark "ffwin-$cid" >/dev/null || true
  done < <(ff_windows)
}

list_tabs() {
  command -v bt >/dev/null 2>&1 || return 0
  # bt list => tab_id \t window_name \t tab_title
  bt list | awk -F'\t' 'NF>=3 {
    tab_id=$1; win=$2; title=$3;
    # Fields: TYPE, TAB_ID, WIN_NAME, TAB_TITLE, LABEL
    printf("T\t%s\t%s\t%s\t  %s — %s\n", tab_id, win, title, win, title)
  }'
}

# Get the current title (.name) of a marked firefox window
get_title_by_mark() {
  local mark="$1"
  "$MSG_BIN" -t get_tree | jq -r --arg m "$mark" '
    ..
    | objects
    | select(.marks? | index($m))
    | .name // empty
  ' | head -n1
}

choice="$(
  { list_windows; list_tabs; } | ${ROFI} "${theme_args[@]}" -dmenu -i -p "Go to"
)" || exit 0

# Parse: TYPE \t ID \t WIN_NAME \t TAB_TITLE \t LABEL
type="${choice%%$'\t'*}"
rest="${choice#*$'\t'}"
id="${rest%%$'\t'*}"; rest="${rest#*$'\t'}"
win_name="${rest%%$'\t'*}"; rest="${rest#*$'\t'}"
tab_title="${rest%%$'\t'*}"

case "$type" in
  W)
    exec "$MSG_BIN" "[con_id=$id]" focus >/dev/null
    ;;
  T)
    # 1) Mark all firefox windows (no focus change)
    mark_ff_windows
    # Ensure we clean up marks on exit
    trap 'unmark_ff_windows' EXIT

    # 2) Activate the tab in Firefox
    bt activate "$id" || true

    # 3) Collect candidate marks:
    #    Prefer windows whose pre-activation name matched bt's window name.
    mapfile -t candidates < <(
      ff_windows | awk -F'\t' -v w="$win_name" '
        $2==w { print "ffwin-" $1 }
      '
    )
    # If no exact name match, consider all firefox windows as candidates.
    if [ "${#candidates[@]}" -eq 0 ]; then
      mapfile -t candidates < <(ff_windows | awk -F'\t' '{ print "ffwin-" $1 }')
    fi

    # 4) Poll for the window whose current title equals the tab title
    chosen=""
    for _ in {1..40}; do
      for m in "${candidates[@]}"; do
        name_now="$(get_title_by_mark "$m")"
        if [ "$name_now" = "$tab_title" ]; then
          chosen="$m"
          break 2
        fi
      done
      sleep 0.06
    done

    if [ -n "$chosen" ]; then
      # Focus exact container by mark
      exec "$MSG_BIN" "[con_mark=$chosen]" focus >/dev/null
    fi

    # 5) Fallbacks
    # Try any firefox window whose title equals the tab title
    any_id="$(
      "$MSG_BIN" -t get_tree | jq -r --arg t "$tab_title" '
        ..
        | objects
        | select(
            .type? == "con"
            and (.nodes|length==0) and (.floating_nodes|length==0)
            and (
              (.app_id? // "") | test("(?i)^firefox")
              or (.window_properties.class? // "") | test("(?i)^firefox")
            )
            and (.name? == $t)
          )
        | .id
      ' | head -n1
    )"
    if [ -n "$any_id" ]; then
      exec "$MSG_BIN" "[con_id=$any_id]" focus >/dev/null
    fi

    # Last resort: focus any Firefox
    exec "$MSG_BIN" "[app_id=\"^firefox\"]" focus >/dev/null
    ;;
esac

