#!/bin/bash
CONFIG_FILE="$HOME/.config/i3/dynamic_workspaces.conf"
TMP_FILE="$(mktemp)"

# Get sorted outputs by X position
mapfile -t outputs < <(xrandr --query | grep ' connected' | while read -r line; do
    output=$(awk '{print $1}' <<< "$line")
    x=$(grep -oP '\d+x\d+\+\K\d+' <<< "$line")
    printf "%d %s\n" "$x" "$output"
done | sort -n | awk '{print $2}')

group_size=${#outputs[@]}
total_workspaces=$((5 * group_size))  # 5 groups × monitor count

{
    # Generate workspace variables
    echo "# Workspace variables"
    for ((ws=1; ws<=15; ws++)); do
        echo "set \$ws$ws \"$ws\""
    done

    # Generate workspace assignments
    echo -e "\n# Workspace output assignments"
    for ((ws=1; ws<=total_workspaces; ws++)); do
        monitor_index=$(( (ws - 1) % group_size ))
        echo "workspace \$ws$ws output ${outputs[$monitor_index]}"
    done

    echo -e "\n# Workspace switches"
    for ((ws=1; ws<=total_workspaces && ws<=10; ws++)); do
        echo "bindsym \$mod+$(($ws % 10)) workspace number \$ws$ws"
    done

    echo -e "\n# Move focused container to workspace"
    for ((ws=1; ws<=total_workspaces && ws <= 10; ws++)); do
        echo "bindsym \$mod+Shift+$(($ws % 10)) move container to workspace number \$ws$ws"
    done

} > "$TMP_FILE"

if ! cmp --silent "$TMP_FILE" "$CONFIG_FILE"; then
    mv "$TMP_FILE" "$CONFIG_FILE"
    i3-msg reload
fi
