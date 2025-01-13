#!/bin/bash

set -e # Stop on error
set +x # Don't print commands

echo "Starting install"

export DOTFILES_PATH=$(pwd)
echo "The current path is: $DOTFILES_PATH"
export OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
    echo "Detected 🍏"
elif [ "$OS" = "Linux" ]; then
    echo "Detected 🐧"
else
    echo "Unsupported OS: $OS 🚫"
    exit 1
fi

# Variables
INSTALL_TMUX=false
CONFIGURE_GIT=false
SHELL_TYPE=""
GIT_NAME=""
GIT_EMAIL=""

# Function to show usage
usage() {
    echo "Usage: $0 -s <zsh|fish> [-t] [-g <name,email>]"
    echo "  -s        Specify which shell to configure (zsh or fish)."
    echo "  -t        Install and configure tmux."
    echo "  -g        Configure git with the provided name and email (e.g., -g 'Name,email@example.com')."
    exit 1
}

# Parse arguments
while getopts ":s:tg:" opt; do
    case ${opt} in
    s)
        SHELL_TYPE=${OPTARG}
        if [[ "$SHELL_TYPE" != "zsh" && "$SHELL_TYPE" != "fish" ]]; then
            echo "Invalid shell type: $SHELL_TYPE. Must be 'zsh' or 'fish'."
            usage
        fi
        ;;
    t)
        INSTALL_TMUX=true
        ;;
    g)
        CONFIGURE_GIT=true
        IFS=',' read -r GIT_NAME GIT_EMAIL <<<"$OPTARG"
        if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
            echo "Invalid git configuration. Must provide both name and email."
            usage
        fi
        ;;
    \?)
        echo "Invalid option: -$OPTARG"
        usage
        ;;
    :)
        echo "Option -$OPTARG requires an argument."
        usage
        ;;
    esac
done

# Check mandatory -s parameter
if [[ -z "$SHELL_TYPE" ]]; then
    echo "Error: -s is a mandatory parameter."
    usage
fi

# Mandatory folders
mkdir -p $HOME/.local/bin # Create bin folder if it doesn't exist
mkdir -p $HOME/.config    # Create share folder if it doesn't exist

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS"

    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Please run the ./install/install_brew.sh script first."
        exit 1
    fi

    echo "Installing required packages"
    brew install micro curl htop unzip fzf atuin
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux... start update and install required packages"
    sudo apt update
    sudo apt install -y git micro curl htop unzip fzf
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh -q | sh
else
    echo "Unsupported OS: $OS"
    exit 1
fi

if $INSTALL_TMUX; then ./install/install_tmux.sh; fi

# Install oh-my-posh and check if it's already installed
if [ -d "$HOME/.oh-my-posh" ]; then
    echo "oh-my-posh is already installed"
else
    echo "oh-my-posh is not installed, installing..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin
fi

# Install and configure the selected shell
if [ "$SHELL_TYPE" = "zsh" ]; then
    echo "Configuring zsh..."
    ./install/install_zsh.sh
elif [ "$SHELL_TYPE" = "fish" ]; then
    echo "Configuring fish..."
    ./install/install_fish.sh
fi

# Configure git if requested
if $CONFIGURE_GIT; then
    echo "Configuring git with name: $GIT_NAME and email: $GIT_EMAIL"
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
fi

echo "Done!"
