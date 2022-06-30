# zsh
sudo apt install zsh
# set zsh as default
chsh -s $(which zsh)

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install basic plugins
cd ~/.oh-my-zsh/custom/plugins \
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
cd

sed -i "/plugins=(git)/c plugins=(\n\tgit\n\tzsh-autosuggestions\n\tzsh-syntax-highlighting\n)" .zshrc

sudo apt install tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
