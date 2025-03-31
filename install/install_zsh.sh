#!/bin/bash

echo "Starting install zsh"

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS"
    if command -v zsh >/dev/null 2>&1; then
        echo "zsh is already installed"
    else
        echo "Installing zsh"
        brew install zsh
    fi

    echo "Setting zsh as the default shell"
    chsh -s /bin/zsh
elif [ "$OS" = "Linux" ]; then
    echo "Detected Linux"
    if command -v zsh >/dev/null 2>&1; then
        echo "zsh is already installed"
    else
        echo "Installing zsh"
        sudo apt install -y zsh
    fi

    echo "Setting zsh as the default shell"
    chsh -s /bin/zsh
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing oh-my-zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Creating .env.zsh"
cat <<EOF >$DOTFILES_PATH/.env.zsh
export DOTFILES_ZSH_PROMPT_EMOJI=🪝
export DOTFILES_TMUX_MAIN_DISK_NAME=__NA__
export DOTFILES_PATH=$DOTFILES_PATH
EOF

# Link the .fishrc file
echo "Linking fish config..."
ln -sf $DOTFILES_PATH/configs/.zshrc $HOME/.zshrc

echo "Zsh setup complete. Starting new Zsh session..."
echo "Restart your terminal..."
