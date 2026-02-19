# Font Installer Scripts

## install_cascadia_code_font.sh

This script downloads and installs the latest version of the Cascadia Code font into `~/.local/share/fonts/cascadia-code`, generates a `cascadia-code.css` file in that folder, and ensures `~/.local/share/fonts/main.css` imports the Cascadia Code CSS.

### Usage

```sh
bash scripts/install_cascadia_code_font.sh
```

- The script is idempotent and safe to run multiple times.
- Requires `curl`, `unzip`, and `grep`.
