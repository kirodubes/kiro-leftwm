#!/usr/bin/env bash


### Check if python-pywal is installed
### Check if dir exists and copy the template in its proper place
if [ -x "$(command -v wal)" ]; then
  if [ ! -d $HOME/.config/wal/templates ] ; then
    mkdir $HOME/.config/wal/templates &&
    cp $HOME/.config/leftwm/themes/current/template-wal/color.leftwm-theme.toml  $HOME/.config/wal/templates
  elif
    [ ! -f $HOME/.config/wal/templates/color.leftwm-theme.toml ] ; then
        cp -f $HOME/.config/leftwm/themes/current/template-wal/color.leftwm-theme.toml  $HOME/.config/wal/templates
  fi
    # Derive the colorscheme from the branded Kiro default wallpaper. `-n` keeps
    # wal from setting the background itself — the theme `up` script owns the
    # wallpaper (feh), so the two never fight.
    default_wallpaper="/usr/share/backgrounds/kiro/kiro-wallpaper.jpg"
    if [ -f "$default_wallpaper" ]; then
      wallpaper="$default_wallpaper"
    else
      wallpaper="$HOME/.config/leftwm/themes/current/backgrounds/kiro1.jpg"
    fi
    wal -n -i "$wallpaper" -a 80
    cat ~/.cache/wal/color.leftwm-theme.toml &&
    ####bat ~/.cache/wal/color.leftwm-theme.ron &&               
    cp -f ~/.cache/wal/color.leftwm-theme.toml $HOME/.config/leftwm/themes/current/theme.toml &&
    
    leftwm command "LoadTheme $HOME/.config/leftwm/themes/current/theme.toml"

else

  # Set the branded default background (pywal not installed).
  if [ -x "$(command -v feh)" ]; then
    if [ -f /usr/share/backgrounds/kiro/kiro-wallpaper.jpg ]; then
      feh --bg-fill /usr/share/backgrounds/kiro/kiro-wallpaper.jpg
    else
      feh --bg-fill $HOME/.config/leftwm/themes/current/backgrounds/kiro1.jpg
    fi
  fi
fi
