#!/bin/bash

#!/bin/bash

# Check if the CHECK_DISK_USAGE environment variable is set and not empty
if [ -z "$CHECK_DISK_USAGE" ]; then
    echo "Disk not set"
    exit 1
fi

# Get the disk usage percentage for the specified disk
usage=$(df -h "$CHECK_DISK_USAGE" 2>/dev/null | awk 'NR==2{print $5}' | sed 's/%//')

# Check if the usage value is empty (indicating an error occurred)
if [ -z "$usage" ]; then
    echo "Error get disk"
    exit 1
fi

# Define color based on usage
if [ "$usage" -lt 75 ]; then
    echo "#[fg=green]/dev/sdb ${usage}%#[fg=default]"
elif [ "$usage" -lt 90 ]; then
    echo "#[fg=yellow]/dev/sdb ${usage}%#[fg=default]"
else
    echo "#[fg=red]/dev/sdb ${usage}%#[fg=default]"
fi
