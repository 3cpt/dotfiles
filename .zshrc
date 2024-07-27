export ZSH="$HOME/.oh-my-zsh"

plugins=(
    aliases
    fzf
    command-not-found
    docker
    docker-compose
    encode64
    git
    gh
    terraform
    wd
    golang
    history
    kubectl
    microk8s
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh_alias

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:$HOME/.local/bin

eval "$(oh-my-posh init zsh --config $HOME/adr/dotfiles/adr.omp.yaml)"
