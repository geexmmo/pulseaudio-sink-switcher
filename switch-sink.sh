#!/bin/bash

# Function to extract human-readable description from pactl output
get_sink_description() {
    local sink_name=$1
    pactl list sinks | 
    awk '/Name: '"$sink_name"'/{flag=1;next}/^$/{flag=0}flag' | 
    grep "Description:" | 
    awk '{$1=""; print $0}' | 
    sed 's/^[ \t]*//;s/[ \t]*$//'
}

# Get list of all sink names
sinks=$(pactl list short sinks | cut -f2)
current_default=$(pactl info | grep 'Default Sink' | cut -d' ' -f3)
next_sink=""

# Determine the next sink in the sequence
while IFS= read -r name; do
  if [ "$name" = "$current_default" ]; then
    next_sink=$(echo "$sinks" | grep -A1 --no-group-separator "$name" | tail -n1)
    if [ -z "$next_sink" ] || [ "$next_sink" = "$name" ]; then
      next_sink=$(echo "$sinks" | head -n1)
    fi
    break
  fi
done <<< "$sinks"

# Switch default sink if a valid next sink was found
if [ -n "$next_sink" ]; then
  pactl set-default-sink "$next_sink"
  
  # Move all active input streams to the new default sink
  for input in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$input" "$next_sink"
  done
  
  # Allow minor delay for system update, then notify user
  sleep 0.1 
  description=$(get_sink_description "$next_sink")
  
  notify-send -i audio-card "Audio Output Switched To:" "$description"
fi
