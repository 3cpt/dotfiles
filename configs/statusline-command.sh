#!/bin/sh
# Claude Code statusLine command
# Mirrors the "adr" oh-my-zsh theme

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir')

# Compute last 2 path components (mirrors zsh %2~)
short_path=$(echo "$cwd" | awk -F'/' '{
    n = NF
    if (n == 1) { print "/" }
    else if (n == 2) { print $NF }
    else { print $(n-1) "/" $n }
}')

# Git info (escapes are expanded by %b in the final printf)
git_info=""
if git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null); then
    git_dirty=""
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        git_dirty=" \033[33mx"
    fi
    git_info=" \033[1;34m(${git_branch}${git_dirty}\033[1;34m)\033[0m"
fi

# bar <used_percent> -> colored 10-cell bar + percent
bar() {
    p=$(printf '%.0f' "$1")
    if [ "$p" -ge 80 ]; then c=31; elif [ "$p" -ge 50 ]; then c=33; else c=32; fi
    filled=$(( (p + 5) / 10 )); [ "$filled" -gt 10 ] && filled=10
    s=""; i=0
    while [ $i -lt 10 ]; do
        if [ $i -lt $filled ]; then s="${s}█"; else s="${s}░"; fi
        i=$((i + 1))
    done
    printf '\033[%sm%s\033[0m %s%%' "$c" "$s" "$p"
}

model=$(echo "$input" | jq -r '.model.display_name // empty')

ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_info=""
[ -n "$ctx_used" ] && ctx_info="  ctx $(bar "$ctx_used")"

# 5-hour session limit + countdown to reset
sess_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
sess_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
sess_info=""
if [ -n "$sess_used" ]; then
    sess_info="  session $(bar "$sess_used")"
    if [ -n "$sess_reset" ]; then
        left=$((sess_reset - $(date +%s)))
        [ "$left" -lt 0 ] && left=0
        sess_info="${sess_info} \033[2mresets in $((left / 3600))h$(printf '%02d' $((left % 3600 / 60)))m\033[0m"
    fi
fi

# 7-day limit: percent + reset date
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
week_info=""
if [ -n "$week_used" ]; then
    week_info="  week $(printf '%.0f' "$week_used")%"
    [ -n "$week_reset" ] && week_info="${week_info} \033[2mresets $(date -r "$week_reset" '+%a %d %b %H:%M')\033[0m"
fi

printf "\033[43m\033[1;30m%s\033[0m \033[1;37m%s\033[0m%b  \033[1;35m%s\033[0m%b%b%b\n" \
    "$(hostname -s)" \
    "$short_path" \
    "$git_info" \
    "$model" \
    "$ctx_info" \
    "$sess_info" \
    "$week_info"
