# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="sunrise"              # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
zstyle ':omz:update' mode auto   # update automatically without asking
zstyle ':omz:update' frequency 7 # update every 7 days

# Oh My Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
    aliases
    git
    history
    kubectx
    fzf-tab
    #zsh-syntax-highlighting
    #zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Show kubectx prompt and time
RPS1='$(kubectx_prompt_info) (%T)'

# Environment
export PATH="$PATH:$HOME/.local/bin:$HOME/.atuin/bin"
export GIT_EDITOR="micro"

# Start tmux automatically on SSH (safe version)
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && -z "$SSH_ORIGINAL_COMMAND" ]]; then
    if tmux has-session 2>/dev/null; then
        exec tmux attach
    else
        exec tmux new-session
    fi
fi

# Load fzf if present
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Atuin
eval "$(atuin init zsh)"
