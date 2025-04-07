#!/bin/bash

# Get the current hostname in uppercase
hostname=$(hostname | tr '[:lower:]' '[:upper:]')

# Use emoji from the DOTFILES_PROMPT_EMOJI environment variable, fallback to ❓ if not set
emoji="${DOTFILES_PROMPT_EMOJI:-❓}"

# Display the prompt, with 📡 if in SSH connection
if [[ -n "$SSH_CONNECTION" ]]; then
    echo "$emoji $hostname 📡"
else
    echo "$emoji $hostname"
fi
