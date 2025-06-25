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
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"
if [ -d "$HOME/google-cloud-sdk/bin" ]; then
    export PATH="$HOME/google-cloud-sdk/bin:$PATH"
fi

# Check for required tools
for tool in fzf gh atuin micro; do
    if ! command -v $tool &>/dev/null; then
        echo "[.zshrc] Warning: $tool not found in PATH."
    fi
done

# Start tmux automatically on SSH (safe version)
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && -z "$SSH_ORIGINAL_COMMAND" ]]; then
    if tmux has-session 2>/dev/null; then
        tmux attach
    else
        tmux new-session
    fi
fi

# Load fzf if present
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source .bash_profile if present (for shared env vars)
if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile" >/dev/null 2>&1
fi

# Atuin
if command -v atuin &>/dev/null; then
    if ! atuin status | grep -q 'Logged in as'; then
        echo "[.zshrc] Warning: Atuin is installed but not logged in. Run 'atuin login' to enable sync."
    fi
    eval "$(atuin init zsh)"
fi

export LANG=en_US.UTF-8
export EDITOR="micro"
export GIT_EDITOR="micro"
export KUBE_EDITOR="micro"
