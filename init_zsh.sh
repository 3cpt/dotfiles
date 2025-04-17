#!/bin/bash

set -e

OS=$(uname -s)
echo "Starting setup zsh in $OS"

# set a var with current dir pwd
PWD=$(pwd)

if [ "$OS" = "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Please run the ./install/install_brew.sh script first."
        exit 1
    fi

    echo "Installing tools"
    brew install micro curl htop unzip fzf atuin zsh tmux # bat zoxide
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux 🐧"

    echo "Updating packages"
    sudo apt update

    echo "Installing required packages"
    sudo apt install -y git micro curl htop unzip fzf zsh tmux # bat
    echo "Installing atuin"
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh -q | sh
else
    echo "Unsupported OS: $OS"
    exit 1
fi

mkdir -p $HOME/.local/bin # Create bin folder if it doesn't exist
mkdir -p $HOME/.config    # Create share folder if it doesn't exist

echo "creating symlinks"
ln -sf /$PWD/configs/.zshrc $HOME/.zshrc
ln -sf /$PWD/configs/aliases.zsh $HOME/.oh-my-zsh/custom/aliases.zsh
ln -sf /$PWD/configs/functions.zsh $HOME/.oh-my-zsh/custom/functions.zsh
ln -sf /$PWD/configs/.tmux.conf $HOME/.tmux.conf
ln -sf /$PWD/configs/config.toml $HOME/.config/atuin/config.toml
ln -sf /$PWD/scripts $HOME/.local/bin

echo "Zsh setup complete. Starting new Zsh session..."
echo "Don't forget to run: source ~/.zshrc"
echo "Make zsh default shell with: chsh -s /bin/zsh"
