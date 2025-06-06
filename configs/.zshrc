# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="adr"                  # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
zstyle ':omz:update' mode auto   # update automatically without asking
zstyle ':omz:update' frequency 7 # update every 7 days

# Oh My Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
    aliases
    fzf-tab
    git
    history
    kubectx
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Some motivation
show_motivation

# Environment
export PATH="$PATH:$HOME/.local/bin:$HOME/.atuin/bin"

if [ -d "$HOME/google-cloud-sdk/bin" ]; then
    export PATH="$PATH:$HOME/google-cloud-sdk/bin"
fi

# Start tmux automatically on SSH (safe version)
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && -z "$SSH_ORIGINAL_COMMAND" ]]; then
    if tmux has-session 2>/dev/null; then
        tmux attach
    else
        tmux new-session
    fi
else
    export TERM=xterm-256color
fi

# Load fzf if present
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Run bash in non-interactive mode to source the .bash_profile
if [ -f "$HOME/.bash_profile" ]; then
    source $HOME/.bash_profile
fi

# Atuin
eval "$(atuin init zsh)"

export LANG=en_US.UTF-8
export EDITOR="micro"
export GIT_EDITOR="micro"
export KUBE_EDITOR="micro"
