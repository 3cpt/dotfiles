#!/bin/bash

sudo apt update
sudo apt upgrade -y

# Install Zsh and Oh-My-Zsh
sudo apt install -y zsh micro curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set zsh as the default shell and before echo about it
echo "zsh is now the default shell, password REQUIRED"
sudo chsh -s $(which zsh)
echo "zsh is now the default shell DONE"

# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install oh-my-posh and create folder if it doesn't exist
mkdir -p $HOME/.local/bin
sudo apt install -y unzip
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin

# Install fzf
sudo apt install -y fzf

# Install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Install lazygit
curl https://raw.githubusercontent.com/jesseduffield/lazygit/master/scripts/install.sh | bash

# Install brew if its not arm
if [ "$(uname -m)" != "aarch64" ]; then
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Test and add brew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Update brew
    brew update
fi

# Add Docker's official GPG key:
sudo apt update
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
newgrp docker

# Symlink .zshrc
ln -s $HOME/adr/dotfiles/.zshrc $HOME/.zshrc

exec zsh
