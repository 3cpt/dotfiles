export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.local/bin:$HOME/.atuin/bin

plugins=(
    aliases
    git
    history
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh_alias
source ~/.zsh_functions

for config_file in $HOME/adr/extra/*.zsh; do
    if [ -r "$config_file" ]; then
        echo "loading extra file: $config_file"
        source "$config_file"
    fi
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Check if the script is running in an SSH session
if [[ -n "$SSH_CONNECTION" ]]; then
    # Update tmux plugins
    ~/.tmux/plugins/tpm/bin/update_plugins all

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
eval "$(oh-my-posh init zsh --config $HOME/adr/dotfiles/adr.omp.yaml)"
