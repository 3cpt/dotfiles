#!/bin/bash

set -e # stop on error
set +x # don't print commands

DOCKER=false
if [ "$1" = "docker" ]; then
    DOCKER=true
    echo "To install docker"
fi

echo "Starting install"
sudo apt update
sudo apt upgrade -y

# Install apt tools
sudo apt install -y zsh micro curl htop unzip fzf

# Zsh setup
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo chsh -s $(which zsh)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
mkdir -p $HOME/.local/bin
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin

# Install brew if its not arm
if [ "$(uname -m)" != "aarch64" ]; then
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Test and add brew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Update brew
    brew update
fi

if [ "$DOCKER" = true ]; then
    echo "Installing docker"
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

# Symlink .zshrc
sudo ln -sf $HOME/adr/dotfiles/.zshrc $HOME/.zshrc
sudo ln -sf $HOME/adr/dotfiles/.zsh_alias $HOME/.zsh_alias

exec zsh

echo "Done!"
