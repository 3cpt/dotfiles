export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.local/bin:$HOME/.atuin/bin

plugins=(
    aliases
    history
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh_alias
source ~/.zsh_functions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Check if the script is running in an SSH session
if [[ -n "$SSH_CONNECTION" ]]; then
    # Check if tmux is already running
    if [ -z "$TMUX" ]; then
        tmux attach || tmux new-session
    fi
fi

eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/adr/dotfiles/adr.omp.yaml)"
