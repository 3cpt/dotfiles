#!/bin/bash

if [ "$OS" = "Darwin" ]; then
    brew install tmux
elif [ "$OS" = "Linux" ]; then
    sudo apt install -y tmux
else
    echo "Unsupported OS: $OS"
    exit 1
fi

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "tpm is already installed"
else
    echo "tpm is not installed"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

ln -sf $DOTFILES_PATH/configs/.tmux.conf $HOME/.tmux.conf

echo "Finished install TMUX"
