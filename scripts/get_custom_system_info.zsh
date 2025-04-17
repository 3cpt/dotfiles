#!/usr/bin/env zsh

get_custom_sysyem_info() {
    # if it's not linux exit
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        return
    fi
    # Get the CPU usage percentage
    local cpu_usage=$(LC_NUMERIC=en_US.UTF-8 top -bn2 -d 0.01 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    local cpu_usage_int=$(printf "%.0f" "$cpu_usage")

    # Get total and used memory in GB
    local mem_total=$(free -h | awk '/^Mem:/ {print $2}')
    local mem_used=$(free -h | awk '/^Mem:/ {print $3}')
    local mem_usage=$(free | awk '/^Mem:/ {print $3/$2*100}')
    local mem_usage_int=$(printf "%.0f" "$mem_usage")
    local mem_info="${mem_used}/${mem_total} (${mem_usage_int}%)"

    # Determine disk stats
    local total_used total_size total_usage
    if [[ -n "$DOTFILES_TMUX_MAIN_DISK_NAME" && "$DOTFILES_TMUX_MAIN_DISK_NAME" != "__NA__" ]]; then
        total_used=$(df -h | awk -v disk="$DOTFILES_TMUX_MAIN_DISK_NAME" '$0 ~ disk {print $3}')
        total_size=$(df -h | awk -v disk="$DOTFILES_TMUX_MAIN_DISK_NAME" '$0 ~ disk {print $2}')
        total_usage=$(df -h | awk -v disk="$DOTFILES_TMUX_MAIN_DISK_NAME" '$0 ~ disk {print $5}' | sed 's/%//')
    else
        total_used=$(df -h --total | awk 'END{print $3}')
        total_size=$(df -h --total | awk 'END{print $2}')
        total_usage=$(df -h --total | awk 'END{print $5}' | sed 's/%//')
    fi

    local total_usage_int=$(printf "%.0f" "$total_usage")

    # Define a helper function to colorize values
    local colorize
    colorize() {
        local usage=$1
        local text=$2
        if ((usage < 75)); then
            echo "#[fg=green]$text#[fg=default]"
        elif ((usage < 90)); then
            echo "#[fg=yellow]$text#[fg=default]"
        else
            echo "#[fg=red]$text#[fg=default]"
        fi
    }

    local cpu_output=$(colorize "$cpu_usage_int" "CPU ${cpu_usage}%")
    local mem_output=$(colorize "$mem_usage_int" "RAM $mem_info")
    local disk_output=$(colorize "$total_usage_int" "DISK $total_used/$total_size ($total_usage%)")

    echo "$cpu_output | $mem_output | $disk_output"
}

get_custom_sysyem_info
