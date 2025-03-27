#!/bin/bash
direction=$1

# Get current focused workspace and output
readarray -t ws_info < <(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num, .output')
current_ws_num=${ws_info[0]}
current_output=${ws_info[1]}

# Determine current group (1-3)
current_group=$(( (current_ws_num - 1) / 3 + 1 ))

# Calculate new group
if [ "$direction" = "next" ]; then
    new_group=$((current_group % 3 + 1))
elif [ "$direction" = "prev" ]; then
    new_group=$(( (current_group - 2) % 3 + 1))
    [ $new_group -le 0 ] && new_group=3
else
    echo "Invalid direction: $direction" >&2
    exit 1
fi

# Determine workspace positions for new group
case $current_output in
    DP-0) position=1 ;;
    DP-4) position=2 ;;
    DP-2) position=3 ;;
    *) position=1 ;; # Fallback to DP-0
esac

# Calculate target workspace for original monitor
new_ws=$(( (new_group - 1) * 3 + position ))

# Calculate all workspaces in new group
ws_dp0=$(( (new_group - 1) * 3 + 1 ))
ws_dp2=$(( (new_group - 1) * 3 + 2 ))
ws_dp4=$(( (new_group - 1) * 3 + 3 ))

# Switch workspaces and return focus to original monitor
i3-msg "workspace number $ws_dp0; \
         workspace number $ws_dp2; \
         workspace number $ws_dp4; \
         workspace number $new_ws" >/dev/null
