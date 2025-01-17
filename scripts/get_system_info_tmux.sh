#!/bin/bash

# Get the CPU usage percentage
cpu_usage=$(LC_NUMERIC=en_US.UTF-8 top -bn2 -d 0.01 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_usage_int=$(printf "%.0f" "$cpu_usage") # Convert to integer for comparison

# Get total and used memory in GB
mem_total=$(free -h | awk '/^Mem:/ {print $2}')
mem_used=$(free -h | awk '/^Mem:/ {print $3}')
mem_usage=$(free | awk '/^Mem:/ {print $3/$2*100}')
mem_usage_int=$(printf "%.0f" "$mem_usage")             # Convert to integer for comparison
mem_info="${mem_used}/${mem_total} (${mem_usage_int}%)" # Round to integer percentage

# Check if DOTFILES_TMUX_MAIN_DISK_NAME is set or equals to __NA__
if [[ -n "$DOTFILES_TMUX_MAIN_DISK_NAME" && "$DOTFILES_TMUX_MAIN_DISK_NAME" != "__NA__" ]]; then
    # Get disk usage for the specific disk
    total_used=$(df -h | awk -v disk="$DOTFILES_TMUX_MAIN_DISK_NAME" '$0 ~ disk {print $3}')
    total_size=$(df -h | awk -v disk="$DOTFILES_TMUX_MAIN_DISK_NAME" '$0 ~ disk {print $2}')
    total_usage=$(df -h | awk -v disk="$DOTFILES_TMUX_MAIN_DISK_NAME" '$0 ~ disk {print $5}' | sed 's/%//')
else
    # Get total disk usage across all disks
    total_used=$(df -h --total | awk 'END{print $3}')
    total_size=$(df -h --total | awk 'END{print $2}')
    total_usage=$(df -h --total | awk 'END{print $5}' | sed 's/%//')
fi

# Convert to integer for comparison
total_usage_int=$(printf "%.0f" "$total_usage")

# Function to colorize output based on usage
colorize() {
    local usage=$1
    local text=$2
    if [ "$usage" -lt 75 ]; then
        echo "#[fg=green]$text#[fg=default]"
    elif [ "$usage" -lt 90 ]; then
        echo "#[fg=yellow]$text#[fg=default]"
    else
        echo "#[fg=red]$text#[fg=default]"
    fi
}

# Colorize CPU, RAM, and Disk usage
cpu_output=$(colorize "$cpu_usage_int" "CPU ${cpu_usage}%")
mem_output=$(colorize "$mem_usage_int" "RAM $mem_info")
disk_output=$(colorize "$total_usage_int" "DISK $total_used/$total_size ($total_usage%)")

# Print the results
echo "$cpu_output | $mem_output | $disk_output"
