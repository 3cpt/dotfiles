#!/bin/bash

# Get the total disk usage percentage for all disks
total_used=$(df -h --total | awk 'END{print $3}')
total_size=$(df -h --total | awk 'END{print $2}')
total_usage=$(df -h --total | awk 'END{print $5}' | sed 's/%//')

# Check if the total usage value is empty (indicating an error occurred)
if [ -z "$total_usage" ]; then
    echo "Error get disk"
    exit 1
fi

# Define color based on total usage
if [ "$total_usage" -lt 75 ]; then
    echo "#[fg=green]DISK: $total_used/$total_size ($total_usage%)#[fg=default]"
elif [ "$total_usage" -lt 90 ]; then
    echo "#[fg=yellow]DISK: $total_used/$total_size ($total_usage%)#[fg=default]"
else
    echo "#[fg=red]DISK: $total_used/$total_size ($total_usage%)#[fg=default]"
fi
