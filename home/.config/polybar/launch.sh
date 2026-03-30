#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar-top
echo "---" | tee -a /tmp/bar.log
polybar bar 2>&1 | tee -a /tmp/bar.log & disown

echo "Bar launched..."
