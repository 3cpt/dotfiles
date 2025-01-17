#!/bin/bash

run_cmd() {
    if $DEBUG; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi
}

# Script to install fish on macOS
echo "Starting install fish"

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS"
    # Check if fish is already installed
    if command -v fish >/dev/null 2>&1; then
        echo "fish is already installed"
    else
        echo "Installing fish"
        run_cmd brew install fish
    fi

    echo "Setting fish as the default shell"
    chsh -s /usr/local/bin/fish
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux"
    # Check if fish is already installed
    if command -v fish >/dev/null 2>&1; then
        echo "fish is already installed"
    else
        echo "Installing fish"
        run_cmd sudo apt install -y fish
    fi

    echo "Setting fish as the default shell"
    chsh -s /usr/bin/fish
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "creating .env.fish"
# Create the envs.fish file with the desired content
cat <<EOF >.env.fish
set -Ux DOTFILES_ZSH_PROMPT_EMOJI 🌀
set -Ux DOTFILES_TMUX_MAIN_DISK_NAME __NA__
set -Ux DOTFILES_PATH $DOTFILES_PATH
EOF

# Link the .fishrc file
echo "Linking fish config..."
ln -sf $DOTFILES_PATH/configs/config.fish $HOME/.config/fish/config.fish
ln -sf $DOTFILES_PATH/.env.fish $HOME/.config/fish/.env.fish

echo "Finished install fish, starting it..."
exec fish
