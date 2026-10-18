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
#   Detect connected monitors and arrange them left-to-right.
#   - ~/.screenlayout/<username>.sh exists : run that saved layout, nothing else.
#   - 0 or 1 screen : enable the single output as primary (or do nothing).
#   - 2+ screens    : place known outputs in PREFERRED_ORDER (left to right),
#                     then append any other connected outputs after them.
# Why:
#   Software can see which outputs are connected but never their physical
#   placement, so when a machine needs a specific left/right order it must be
#   stated. This is done per-hostname below: empty by default (auto-arrange,
#   correct for most setups), with a named override only for known machines.
#   Other users: run `hostname` to get your box name, then add a branch for it.
#   Tip: the GUI tool `arandr` lets you drag monitors into position and
#   "Save As" a ready-made xrandr script — read your output order off that.
###############################################################################

# Preferred left-to-right monitor order. Empty = auto-arrange whatever is
# connected, in xrandr's own order. Outputs not listed are appended after the
# listed ones. Override per machine via the hostname check below.
PREFERRED_ORDER=()
# Example: HDMI-2 is physically on the LEFT, DP-1 on the RIGHT, but X
# auto-detects them swapped — pin the correct order for that one box.
# if [ "$(hostname)" = "mybox" ]; then
#     PREFERRED_ORDER=(HDMI-2 DP-1)
# fi

# A saved arandr/xrandr layout named after the current user wins, as in the
# other Kiro TWMs. Generate it with arandr, save it to ~/.screenlayout/<username>.sh
if [ -f "$HOME/.screenlayout/$(whoami).sh" ]; then
    sh "$HOME/.screenlayout/$(whoami).sh"
    exit 0
fi

# Connected outputs, in the order xrandr reports them.
mapfile -t CONNECTED < <(xrandr --query | awk '/ connected/ {print $1}')

# Single (or no) monitor: make the one we have primary, then done. Keep the
# mode it already has: --auto would reset it to the preferred mode, which in
# VirtualBox is 1024x768 and undoes the VM's own resize on every theme reload.
if [ "${#CONNECTED[@]}" -le 1 ]; then
    if [ "${#CONNECTED[@]}" -eq 1 ]; then
        if xrandr --query | grep -qE "^${CONNECTED[0]} connected( primary)? [0-9]+x[0-9]+\+"; then
            xrandr --output "${CONNECTED[0]}" --primary
        else
            xrandr --output "${CONNECTED[0]}" --auto --primary
        fi
    fi
    exit 0
fi

# Build the ordered list: preferred-and-connected first, then any extras.
ORDER=()
for out in "${PREFERRED_ORDER[@]}"; do
    for c in "${CONNECTED[@]}"; do
        if [ "$out" = "$c" ]; then
            ORDER+=("$out")
        fi
    done
done
for c in "${CONNECTED[@]}"; do
    found=0
    for o in "${ORDER[@]}"; do
        if [ "$c" = "$o" ]; then found=1; fi
    done
    if [ "$found" -eq 0 ]; then
        ORDER+=("$c")
    fi
done

# Lay them out left-to-right: first output is primary at 0x0, rest --right-of.
args=(--output "${ORDER[0]}" --auto --primary --pos 0x0)
prev="${ORDER[0]}"
for out in "${ORDER[@]:1}"; do
    args+=(--output "$out" --auto --right-of "$prev")
    prev="$out"
done

xrandr "${args[@]}"
