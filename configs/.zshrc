# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Environment
export PATH="$PATH:$HOME/.local/bin:$HOME/.atuin/bin"
export GIT_EDITOR="micro"

# Load environment variables from .env.zsh (equivalente ao .env.fish)
if [ -f "$DOTFILES_PATH/.env.zsh" ]; then
    echo "Loading .env.zsh"
    source "$DOTFILES_PATH/.env.zsh"
fi

# Oh My Zsh plugins
plugins=(
    aliases
    gcloud
    git
    gh
    history
    kubectl
    rand-quote
    terraform
    zbell
    zoxine
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Load custom functions
if [ -f "$DOTFILES_PATH/configs/functions.zsh" ]; then
    source "$DOTFILES_PATH/configs/functions.zsh"
fi

# Load aliases
if [ -f "$DOTFILES_PATH/configs/aliases.zsh" ]; then
    source "$DOTFILES_PATH/configs/aliases.zsh"
fi

# Load extra files from $DOTFILES_PATH/extra if the folder exists
if [ -d "$DOTFILES_PATH/extra" ]; then
    for config_file in "$DOTFILES_PATH/extra"/*.zsh; do
        if [ -r "$config_file" ]; then
            echo "Loading extra file: $config_file"
            source "$config_file"
        fi
    done
else
    echo "No extra files found in: $DOTFILES_PATH/extra"
fi

# Start tmux automatically on SSH (safe version)
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && -z "$SSH_ORIGINAL_COMMAND" ]]; then
    if tmux has-session 2>/dev/null; then
        exec tmux attach
    else
        exec tmux new-session
    fi
fi

# Emulate .bash_profile if it exists
[[ -e ~/.bash_profile ]] && emulate sh -c 'source ~/.bash_profile'

# Load fzf if present
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Atuin
eval "$(atuin init zsh)"

# Oh My Posh prompt
eval "$(oh-my-posh init zsh --config $DOTFILES_PATH/configs/adr.omp.yaml)"
