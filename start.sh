#!/bin/bash

set -e # Stop on error

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

while getopts ":s:g:t" opt; do
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

# Ensure mandatory parameters
if [[ -z "$SHELL_TYPE" ]]; then
    echo "Error: -s is a mandatory parameter."
    usage
fi

echo "Starting..."

export DOTFILES_PATH=$(pwd)
echo "Current path: $DOTFILES_PATH"

export OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS 🍏"

    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Please run the ./install/install_brew.sh script first."
        exit 1
    fi

    echo "Installing required packages"
    brew install micro curl htop unzip fzf atuin zoxide bat
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux 🐧"
    echo "Updating packages"
    sudo apt update
    echo "Installing required packages"
    sudo apt install -y git micro curl htop unzip fzf bat
    echo "Installing atuin"
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh -q | sh
    echo "Installing zoxide"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "Unsupported OS: $OS 🚫"
    exit 1
fi

# Mandatory folders
mkdir -p $HOME/.local/bin # Create bin folder if it doesn't exist
mkdir -p $HOME/.config    # Create share folder if it doesn't exist

if $INSTALL_TMUX; then ./install/install_tmux.sh; fi

# Install oh-my-posh and check if it's already installed
if [ -d "$HOME/.oh-my-posh" ]; then
    echo "oh-my-posh is already installed"
else
    echo "oh-my-posh is not installed, installing..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin
fi

# Configure git if requested
if $CONFIGURE_GIT; then
    echo "Configuring git with name: $GIT_NAME and email: $GIT_EMAIL"
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
fi

echo "Configuring symlinks..."
ln -sf $DOTFILES_PATH/configs/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES_PATH/configs/config.toml $HOME/.config/atuin/config.toml

# Install and configure the selected shell
if [ "$SHELL_TYPE" = "zsh" ]; then
    echo "Configuring zsh..."
    ./install/install_zsh.sh
elif [ "$SHELL_TYPE" = "fish" ]; then
    echo "Configuring fish..."
    ./install/install_fish.sh
fi

echo "Done!"
