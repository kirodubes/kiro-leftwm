#!/bin/bash
set -euo pipefail
###############################################################################
# Author  : Erik Dubois
# Website : https://kiroproject.be
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   Adapt the leftwm tag keybindings in config.ron to the active keyboard
#   layout. leftwm binds by X11 keysym, and on a Belgian (be / AZERTY) layout
#   the number row emits symbols (ampersand, eacute, ...) instead of digits, so
#   mod+1..9 would not reach the tags without a remap. This rewrites only the 9
#   tag-key bindings in place, in whichever direction is needed:
#     - AZERTY target : digit keysyms  -> azerty symbol keysyms
#     - QWERTY target : azerty symbols -> digit keysyms (restore)
#   With no argument the layout is auto-detected via setxkbmap.
# Why:
#   config.ron is the single hand-maintained source (QWERTY). Deriving AZERTY
#   here means one file to edit instead of three that drift apart. The edit is
#   anchored to `key: "N")` (the closing paren disambiguates from `value: "N",`)
#   and is idempotent in both directions, so it is safe to run on every login.
###############################################################################

CONFIG="${1:-}"   # optional explicit target: be|azerty|qwerty|us  (else auto)
RON="$HOME/.config/leftwm/config.ron"

# digit -> azerty-layout keysym, in tag order 1..9.
declare -A AZERTY=(
    [1]=ampersand [2]=eacute   [3]=quotedbl
    [4]=apostrophe [5]=parenleft [6]=section
    [7]=egrave    [8]=exclam    [9]=ccedilla
)

# Resolve the requested target into "azerty" or "qwerty".
case "${CONFIG,,}" in
    be|azerty)        target=azerty ;;
    qwerty|us|"")
        if [ -z "$CONFIG" ]; then
            layout=$(setxkbmap -v 2>/dev/null | awk -F "+" '/symbols/ {print $2}')
            [ "$layout" = "be" ] && target=azerty || target=qwerty
        else
            target=qwerty
        fi
        ;;
    *) target=qwerty ;;
esac

[ -f "$RON" ] || exit 0

# Build the sed program for the chosen direction. Anchoring on `key: "X")`
# leaves `value: "X",` untouched.
args=()
for n in "${!AZERTY[@]}"; do
    sym="${AZERTY[$n]}"
    if [ "$target" = "azerty" ]; then
        args+=(-e "s/key: \"$n\"\\)/key: \"$sym\")/g")
    else
        args+=(-e "s/key: \"$sym\"\\)/key: \"$n\")/g")
    fi
done

sed -E -i "${args[@]}" "$RON"
