export ZSH="$HOME/.oh-my-zsh"

plugins=(aliases command-not-found encode64 git gh terraform wd golang history kubectl microk8s tmux zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/snap/bin

# if [ -z "" ]; then
#     tmux attach-session -t default || tmux new-session -s default
# fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh_alias
source ~/.zsh_functions

# Get the OS type
OS_TYPE=$(uname)

# Determine the Oh My Posh path based on the OS
if [ "$OS_TYPE" = "Darwin" ]; then
    OMP_PATH="$(brew --prefix oh-my-posh)/bin/oh-my-posh"
else
    OMP_PATH=$HOME
fi

# Determine the theme based on the hostname
if [ "$(whoami)" = "andrecorreia" ]; then
    OMP_THEME="$OMP_PATH/themes/dracula.omp.json"
else
    OMP_THEME="$OMP_PATH/themes/hotstick.minimal.omp.json"
fi

# Initialize Oh My Posh with the determined configuration
eval "$(oh-my-posh init zsh --config $OMP_THEME)"
