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
    #brew update

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

# Zsh setup but check first if it's already installed
if command -v zsh &>/dev/null; then
    echo "zsh is already installed"
else
    echo "zsh is not installed"
fi

# Install oh-my-zsh and check if it's already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed"
else
    echo "oh-my-zsh is not installed"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    sudo chsh -s $(which zsh)
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

mkdir -p $HOME/.local/bin # Create bin folder if it doesn't exist

# Install oh-my-posh and check if it's already installed
if [ -d "$HOME/.oh-my-posh" ]; then
    echo "oh-my-posh is already installed"
else
    echo "oh-my-posh is not installed"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin
fi

# Install tpm (Tmux Plugin Manager) and check if it's already installed
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "tpm is already installed"
else
    echo "tpm is not installed"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Symlink .zshrc
ln -sf $HOME/.adr/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/.adr/dotfiles/.zsh_alias $HOME/.zsh_alias
ln -sf $HOME/.adr/dotfiles/.zsh_functions $HOME/.zsh_functions
ln -sf $HOME/.adr/dotfiles/.tmux.conf $HOME/.tmux.conf

exec zsh

echo "Done!"
