#!/usr/bin/env bash

# CB left click: a random wallpaper from the theme's own backgrounds folder.
# With pywal installed the bar and borders are recoloured from it too; the
# right click (wal.sh) goes back to the branded Kiro default.

backgrounds=("$HOME"/.config/leftwm/themes/current/backgrounds/*)
[ -f "${backgrounds[0]}" ] || exit 0
wallpaper="${backgrounds[$((RANDOM % ${#backgrounds[@]}))]}"

if [ -x "$(command -v feh)" ]; then
  feh --no-fehbg --bg-fill "$wallpaper"
fi

### Check if python-pywal is installed
### Check if dir exists and copy the template in its proper place
if [ -x "$(command -v wal)" ]; then
  if [ ! -d "$HOME"/.config/wal/templates ] ; then
    mkdir -p "$HOME"/.config/wal/templates &&
    cp "$HOME"/.config/leftwm/themes/current/template-wal/color.leftwm-theme.toml "$HOME"/.config/wal/templates
  elif
    [ ! -f "$HOME"/.config/wal/templates/color.leftwm-theme.toml ] ; then
        cp -f "$HOME"/.config/leftwm/themes/current/template-wal/color.leftwm-theme.toml "$HOME"/.config/wal/templates
  fi
    # `-n`: feh above already set the wallpaper, wal only builds the colours.
    wal -n -i "$wallpaper" -a 80
    cp -f ~/.cache/wal/color.leftwm-theme.toml "$HOME"/.config/leftwm/themes/current/theme.toml &&
    leftwm command "LoadTheme $HOME/.config/leftwm/themes/current/theme.toml"
fi
