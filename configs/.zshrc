export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.local/bin:$HOME/.atuin/bin
export DOTFILES_PATH="__DOTFILES_PATH__"
export EXTRA_FILES_PATH="__EXTRA_FILES_PATH__"

plugins=(
    aliases
    git
    history
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh_functions

# Load extra files if extra folder exists
if [ -d "$EXTRA_FILES_PATH" ] && [ "$EXTRA_FILES_PATH" != "__EXTRA_FILES_PATH__" ]; then
    for config_file in "$EXTRA_FILES_PATH"/*.zsh; do
        if [ -r "$config_file" ]; then
            echo "Loading extra file: $config_file"
            source "$config_file"
        fi
    done
else
    echo "Invalid EXTRA_FILES_PATH: $EXTRA_FILES_PATH"
fi

# Check if the script is running in an SSH session
if [[ -n "$SSH_CONNECTION" ]]; then
    # Check if tmux is already running
    if [ -z "$TMUX" ]; then
        tmux attach || tmux new-session
    fi
fi

# Emulate .bash_profile
[[ -e ~/.bash_profile ]] && emulate sh -c 'source ~/.bash_profile'

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh --config $DOTFILES_PATH/configs/adr.omp.yaml)"
