#!/bin/bash
direction=$1

# Get current workspace info
readarray -t current < <(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).num, select(.focused).output')
current_ws=${current[0]}
current_output=${current[1]}

# Get sorted outputs by X position (left to right)
mapfile -t outputs < <(xrandr --query | grep ' connected' | while read -r line; do
    output=$(awk '{print $1}' <<< "$line")
    x=$(grep -oP '\d+x\d+\+\K\d+' <<< "$line")
    printf "%d %s\n" "$x" "$output"
done | sort -n | awk '{print $2}')

group_size=${#outputs[@]}
total_groups=5
workspaces_per_group=$((group_size))

current_group=$(( (current_ws - 1) / workspaces_per_group ))

# Calculate new group
case "$direction" in
    next) new_group=$(( (current_group + 1) % total_groups )) ;;
    prev) new_group=$(( (current_group - 1 + total_groups) % total_groups )) ;;
    *) exit 1 ;;
esac

# Calculate target workspaces for all outputs
declare -A target_workspaces
for ((i=0; i<group_size; i++)); do
    ws_num=$(( new_group * workspaces_per_group + i + 1 ))
    target_workspaces["${outputs[$i]}"]=$ws_num
done

# Determine execution order based on current monitor position
if [[ "$current_output" == "${outputs[0]}" ]]; then
    # Leftmost monitor: switch right first
    switch_order=("${outputs[@]:1}" "$current_output")
else
    # Other monitors: switch left first
    switch_order=("${outputs[@]}")
fi

# Build single i3-msg command with all switches
command_string=""
for output in "${switch_order[@]}"; do
    command_string+="workspace number ${target_workspaces[$output]}; "
done
command_string+="workspace number ${target_workspaces[$current_output]}"

# Execute as single atomic operation
i3-msg "$command_string" >/dev/null
