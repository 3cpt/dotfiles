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
