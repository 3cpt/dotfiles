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

Or store them once in Proton Pass as a login item `Atuin` (username, password,
custom field `key` = the mnemonic) and run `atuin-login` on new machines.

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
./start.sh
```

## License

[MIT](LICENSE)
