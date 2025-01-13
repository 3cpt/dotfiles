#!/bin/bash

sudo apt install -y zsh
chsh -s /bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

echo 'source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>~/.zshrc
echo 'source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
echo 'source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions/zsh-completions.plugin.zsh' >>~/.zshrc

# Make zsh the default shell
chsh -s /bin/zsh

sed -i "s|__DOTFILES_PATH__|$DOTFILES_PATH|g" ~/.zshrc

# Link the .zshrc file
ln -sf $HOME/.adr/dotfiles/.zshrc $HOME/.zshrc

# Reload zsh configuration
exec zsh
