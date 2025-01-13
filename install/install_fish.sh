#!/bin/bash

# Script to install fish on macOS
echo "Starting install"

# Detect the OS
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS"
    # Check if fish is already installed
    if command -v fish >/dev/null 2>&1; then
        echo "fish is already installed"
    else
        # Install fish
        brew install fish
    fi

    chsh -s /usr/local/bin/fish
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux"
    # Check if fish is already installed
    if command -v fish >/dev/null 2>&1; then
        echo "fish is already installed"
    else
        # Install fish
        sudo apt install -y fish
    fi

    # Set fish as the default shell
    chsh -s /usr/bin/fish
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Set dotfiles path
sed -i "s|__DOTFILES_PATH__|$DOTFILES_PATH|g" ~/.config/fish/config.fish

echo "Finished install"

# Link the .fishrc file
ln -sf $DOTFILES_PATH/configs/config.fish $HOME/.config/fish/config.fish

# Reload fish configuration
exec fish
