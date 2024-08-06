#!/bin/bash

# Get the current hostname in uppercase
hostname=$(hostname | tr '[:lower:]' '[:upper:]')
ssh_indicator=""

# Add thunder emoji if in SSH connection
if [[ -n "$SSH_CONNECTION" ]]; then
    ssh_indicator="⚡"
fi

# Define the emoji based on the hostname
if [[ "$hostname" == *WORKSTATION* ]]; then
    echo "⚓️ $hostname $ssh_indicator"
elif [[ "$hostname" == *ANDRES* ]]; then
    echo "🏠 $hostname $ssh_indicator"
elif [[ "$hostname" == *PI* ]]; then
    echo "🍓 $hostname $ssh_indicator"
elif [[ "$hostname" == *PENGUIN* ]]; then
    echo "🐧 $hostname $ssh_indicator"
else
    echo "❓ $hostname $ssh_indicator"
fi
