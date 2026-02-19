# dotfiles

dotfiles

* how to set env vars
* how to configure gh cli
* how to configure gcloud cli

## How to

### Atuin

```bash
atuin status    # to get username
atuin key       # to get the mnemonic phrase
atuin login     # to login into the account
```

## Fish as default on Mac

* add /opt/homebrew/bin/fish to the `/etc/shells` file
* run `chsh -s /opt/homebrew/bin/fish`

## Debug

* oh-my-posh: `oh-my-posh debug`

## Script to start

```bash
cd $HOME && \
sudo apt update && \
sudo apt install -y git && \
git clone https://github.com/3cpt/dotfiles.git && \
cd dotfiles
```

Then run:

```bash
./zsh.sh
```

## License

[MIT](LICENSE)
