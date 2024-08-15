#!/bin/bash

set -e # stop on error
set +x # don't print commands

echo "Starting install"

# Detect the OS
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS"

    # Install Homebrew if it's not installed
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Update Homebrew
    brew update

    # Install brew tools
    brew install zsh micro curl htop unzip fzf tmux atuin

elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux"

    # Update the package list
    sudo apt update
    sudo apt upgrade -y

    # Install apt tools
    sudo apt install -y zsh micro curl htop unzip fzf tmux

    # Install Atuin
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh -q | sh
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Zsh setup
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
sudo chsh -s $(which zsh)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
mkdir -p $HOME/.local/bin
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin

# Install tpm (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Symlink .zshrc
ln -sf $HOME/.adr/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/.adr/dotfiles/.zsh_alias $HOME/.zsh_alias
ln -sf $HOME/.adr/dotfiles/.zsh_functions $HOME/.zsh_functions
ln -sf $HOME/.adr/dotfiles/.tmux.conf $HOME/.tmux.conf

exec zsh

echo "Done!"
