# dotfiles

## What

- MacOS defaults
- System defaults
- System alias

## Alias

## Tools

- zsh
- ohmyzsh
- brew
- kubectl
- lazydocker
- lazygit
- fzf

### Specific setup

- docker
- vscode
- github desktop
- node
- go

### For raspeberry

- tmux
- oh-my-posh at .local/bin
- snap
- microk8s

## Test

docker build -t mydebian .
docker run -it mydebian

## Script to start

```bash
cd $HOME && \
sudo apt update && \
sudo apt install -y git && \
mkdir -p adr && \
cd adr && \
git clone https://github.com/3cpt/dotfiles.git && \
cd dotfiles && \
git checkout v3 && \
chmod +x install_linux.sh && \
./install_linux.sh
```

## License

[MIT](LICENSE)
