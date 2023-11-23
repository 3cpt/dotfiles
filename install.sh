#!/bin/bash

echo "🚗 Starting installation..."

# Function to determine if sudo is required
use_sudo() {
    if [ "$(id -u)" != "0" ]; then
        echo "sudo"
    fi
}

SUDO=$(use_sudo)

# Check for Operating System
OS="$(uname)"
echo "🖥️  Operating System: $OS"

# Function to install Zsh and Oh-My-Zsh
install_zsh() {
    echo "🐚 Installing Zsh..."
    if [ "$OS" = "Darwin" ]; then
        brew install zsh
    else
        $SUDO apt update
        $SUDO apt-get install -y git curl unzip zsh fontconfig
    fi

    echo "🔮 Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install Zsh and Oh-My-Zsh
install_zsh

# Install basic tools
echo "🔨 Installing tmux, git, lazydocker, and fzf..."
if [ "$OS" = "Darwin" ]; then
    brew install tmux git lazydocker fzf

    echo "🎨 Installing oh-my-posh and fonts..."
    brew install jandedobbeleer/oh-my-posh/oh-my-posh

    brew install fontconfig
    if ! fc-list | grep -qi "FiraCode"; then
        echo "Installing FiraCode font..."
        oh-my-posh font install
    else
        echo "FiraCode font is already installed."
    fi

else
    $SUDO apt-get install -y tmux git fzf
    # lazydocker installation for Linux
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

    echo "🎨 Installing oh-my-posh and fonts..."
    curl -s https://ohmyposh.dev/install.sh | bash -s

    if ! fc-list | grep -qi "FiraCode"; then
        echo "Installing FiraCode font..."
        oh-my-posh font install
    else
        echo "FiraCode font is already installed."
    fi
fi

# Install Docker and VSCode for macOS
if [ "$OS" = "Darwin" ]; then
    echo "🍏 Installing Docker and Visual Studio Code for macOS..."
    brew install --cask docker visual-studio-code
fi

# Install Oh-My-Zsh plugins
echo "🔌 Installing Oh-My-Zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Create or append custom alias and functions files
echo "🔗 Setting up custom alias and function files..."
touch ~/.zsh_alias
touch ~/.zsh_functions

# Set Zsh as the default shell
ZSH_PATH=$(which zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "🐚 Setting Zsh as the default shell..."
    chsh -s "$ZSH_PATH"
else
    echo "🐚 Zsh is already the default shell."
fi

# Create a symlink for .zshrc (ensure source path is correct)
echo "🔗 Creating a symlink for .zshrc..."
ln -sf $HOME/dotfiles/.zshrc ~/.zshrc

echo "🏁 Installation complete. Please restart your terminal."
