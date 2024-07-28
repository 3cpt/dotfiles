#!/bin/bash

set -e # stop on error
set +x # don't print commands

DOCKER=false
if [ "$1" = "docker" ]; then
    DOCKER=true
    echo "To install docker"
fi

echo "Starting install"

# Detect the OS
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS"

    # macOS update commands (similar to apt update/upgrade on Linux)
    softwareupdate --install --all

    # Install Homebrew if it's not installed
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Update Homebrew
    brew update

    # Install brew tools
    brew install zsh micro curl htop unzip fzf tmux

elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux"

    # Update the package list
    sudo apt update
    sudo apt upgrade -y

    # Install apt tools
    sudo apt install -y zsh micro curl htop unzip fzf tmux
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
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

if [ "$DOCKER" = true ]; then
    if [ "$OS" = "Darwin" ]; then
        echo "Installing Docker on macOS"
        # Install Docker using Homebrew
        brew install --cask docker

        # Start Docker (requires user interaction for permissions)
        open /Applications/Docker.app

        echo "Please follow the instructions in the Docker app to complete the installation."
    elif [ "$OS" = "Linux" ]; then
        echo "Installing Docker on Linux"
        sudo apt install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
            sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt-get update

        # Install Docker Engine, containerd, and Docker Compose
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Linux post-installation steps for Docker Engine
        sudo groupadd docker
        sudo usermod -aG docker $USER
        sudo newgrp docker

        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi
fi

# Symlink .zshrc
ln -sf $HOME/adr/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/adr/dotfiles/.zsh_alias $HOME/.zsh_alias
ln -sf $HOME/adr/dotfiles/.tmux.conf $HOME/.tmux.conf

exec zsh

echo "Done!"
