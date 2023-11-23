#!/bin/bash

echo "🚗 Starting installation..."

# Check for Operating System
OS="$(uname)"
echo "🖥️  Operating System: $OS"

# Function to install Homebrew
install_brew() {
    echo "🍺 Installing Homebrew..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew update
    brew upgrade
}

# Function to install Zsh and Oh-My-Zsh
install_zsh() {
    echo "🐚 Installing Zsh and Oh-My-Zsh..."
    brew install zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install Homebrew, Zsh, and Oh-My-Zsh
install_brew
install_zsh

# Install basic tools
echo "🔨 Installing tmux, git, lazydocker, and fzf..."
brew install git lazydocker fzf micro kubectl # tmux

# Install oh-my-posh
echo "🎨 Installing oh-my-posh and fonts..."
brew install jandedobbeleer/oh-my-posh/oh-my-posh
oh-my-posh font install

# Install fzf useful key bindings and fuzzy completion
echo "🔍 Setting up fzf..."
"$(brew --prefix)/opt/fzf/install"

# Install Docker and VSCode for macOS
if [ "$OS" = "Darwin" ]; then
    echo "🍏 Installing applications for macOS..."
    brew install --cask docker visual-studio-code
    brew install iterm2 node postman robo-3t vlc slack spotify maccy

    echo "🛠️  Applying macOS defaults..."
    sh macosdefaults.sh
fi

# Install Oh-My-Zsh plugins
echo "🔌 Installing Oh-My-Zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

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
ln -sf ~/dotfiles/.zshrc ~/.zshrc

echo "🏁 Installation complete. Please restart your terminal."
