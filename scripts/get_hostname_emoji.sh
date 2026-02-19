#!/bin/bash
set -euo pipefail

# Print hostname with emoji for prompt or tmux status line
# Use DOTFILES_PROMPT_EMOJI env var, fallback to ❓
# Show network emoji if in SSH

if ! command -v hostname >/dev/null 2>&1; then
    echo "[get_hostname_emoji.sh] hostname command not found" >&2
    exit 1
fi

# Get the current hostname in uppercase
hostname=$(hostname | tr '[:lower:]' '[:upper:]')

# Use emoji from the DOTFILES_PROMPT_EMOJI environment variable, fallback to ❓ if not set
emoji="${DOTFILES_PROMPT_EMOJI:-❓}"

# Display the prompt, with 📡 if in SSH connection
if [[ -n "${SSH_CONNECTION:-}" ]]; then
    echo "$emoji $hostname 📡"
else
    echo "$emoji $hostname"
fi
