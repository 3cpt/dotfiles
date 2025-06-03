#!/bin/bash

set -e

# Resolve script path and current directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CURRENT_DIR="$(pwd)"

# Only allow running the script if you're in the same folder as the script
if [[ "$SCRIPT_DIR" != "$CURRENT_DIR" ]]; then
    echo "❌ You must run this script from within its own folder:"
    echo "   cd $SCRIPT_DIR && ./install.sh"
    exit 1
fi

# ... rest of your installation logic ...
echo "✅ Running install from the correct folder: $SCRIPT_DIR"

OS=$(uname -s)
echo "Starting setup zsh in $OS"

if [ "$OS" = "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Please run the ./install/install_brew.sh script first."
        exit 1
    fi

    echo "Installing tools"
    brew install micro curl htop unzip fzf atuin zsh tmux # bat zoxide
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux 🐧"

    echo "Updating packages"
    sudo apt update

    echo "Installing required packages (excluding held packages)"
    held=$(sudo apt-mark showhold | tr '\n' ' ')
    packages=(git micro curl htop unzip fzf zsh tmux xclip kubectx) # bat

    # Filter out held packages
    to_install=()
    for pkg in "${packages[@]}"; do
        if ! [[ " $held " == *" $pkg "* ]]; then
            to_install+=("$pkg")
        else
            echo "⏸ Skipping held package: $pkg"
        fi
    done

    # Only install if there's something left
    if ((${#to_install[@]} > 0)); then
        sudo apt install -y "${to_install[@]}"
    else
        echo "✅ All required packages are held or already handled."
    fi

    echo "Installing atuin"
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh -q | sh

    echo "Installing lazydocker"
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

    echo "Installing k9s"
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb && sudo apt install ./k9s_linux_amd64.deb && rm k9s_linux_amd64.deb
else
    echo "Unsupported OS: $OS"
    exit 1
fi

mkdir -p $HOME/.local/bin # Create bin folder if it doesn't exist
mkdir -p $HOME/.config    # Create share folder if it doesn't exist

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed"
else
    echo "oh-my-zsh is not installed, installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Installing zsh-autosuggestions"
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed"
else
    echo "zsh-autosuggestions is not installed, installing..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo "Installing zsh-syntax-highlighting"
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting is already installed"
else
    echo "zsh-syntax-highlighting is not installed, installing..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "Installing fzf-tab"
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
    echo "fzf-tab is already installed"
else
    echo "fzf-tab is not installed, installing..."
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab
fi

echo "creating symlinks"
ln -sf $(pwd)/configs/.zshrc $HOME/.zshrc
ln -sf $(pwd)/configs/aliases.zsh $HOME/.oh-my-zsh/custom/aliases.zsh
ln -sf $(pwd)/configs/functions.zsh $HOME/.oh-my-zsh/custom/functions.zsh
ln -sf $(pwd)/configs/motivation.zsh $HOME/.oh-my-zsh/custom/motivation.zsh
ln -sf $(pwd)/configs/.tmux.conf $HOME/.tmux.conf
ln -sf $(pwd)/configs/config.toml $HOME/.config/atuin/config.toml
ln -sf $(pwd)/scripts/get_custom_system_info.zsh $HOME/.local/bin/get_custom_system_info
ln -sf $(pwd)/scripts/k8s_info_tmux.zsh $HOME/.local/bin/k8s_info_tmux

mkdir -p $HOME/.oh-my-zsh/custom/themes
ln -sf $(pwd)/configs/adr.zsh-theme $HOME/.oh-my-zsh/custom/themes/adr.zsh-theme

echo "Zsh setup complete. Starting new Zsh session..."
echo "Don't forget to run: source ~/.zshrc"
echo "Make zsh default shell with: chsh -s /bin/zsh"
