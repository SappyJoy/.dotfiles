#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Check if the virtual "FILM" monitor exists
if xrandr --listmonitors | grep -q " FILM"; then
  # --- FILM MODE ---
  # Launch the bar defined as [bar/film]
  polybar --reload film &
else
  # Otherwise, launch a bar on each detected monitor
  if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR=$m polybar --reload main &
    done
  else
    polybar --reload main &
  fi
fi

echo "Polybar launched..."
