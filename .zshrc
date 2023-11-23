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

eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/dracula.omp.json)"
