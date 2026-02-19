#!/bin/bash
set -e

# Variables
FONT_DIR="$HOME/.local/share/fonts/cascadia-code"
CSS_FILE="$FONT_DIR/cascadia-code.css"
MAIN_CSS="$HOME/.local/share/fonts/main.css"
REPO="microsoft/cascadia-code"
TMP_DIR="$(mktemp -d)"

# Ensure font directory exists
mkdir -p "$FONT_DIR"

# Get latest release download URL for ttf files
API_URL="https://api.github.com/repos/microsoft/cascadia-code/releases/latest"
ASSET_URL=$(curl -sL $API_URL | grep browser_download_url | grep 'CascadiaCode-.*.zip' | head -n1 | cut -d '"' -f4)

if [[ -z "$ASSET_URL" ]]; then
    echo "Could not find Cascadia Code font download URL."
    echo "ASSET_URL: $ASSET_URL"
    exit 1
fi

# Download and extract
cd "$TMP_DIR"
curl -LO "$ASSET_URL"
ZIP_FILE=$(basename "$ASSET_URL")
unzip -o "$ZIP_FILE" -d "$FONT_DIR"

font_file=$(find "$FONT_DIR" -type f \( -name "CascadiaCode.ttf" -o -name "CascadiaCode-Regular.ttf" -o -name "CascadiaCodePL.ttf" -o -name "CascadiaCodePL-Regular.ttf" \) | head -n1)
if [[ -z "$font_file" ]]; then
    font_file=$(find "$FONT_DIR" -type f -name "*.ttf" | head -n1)
fi
if [[ -z "$font_file" ]]; then
    echo "No .ttf files found after extracting Cascadia Code."
    exit 1
fi
rel_font_path="${font_file#$FONT_DIR/}"

# Generate cascadia-code.css
cat >"$CSS_FILE" <<EOF
@font-face {
    font-family: 'Cascadia Code';
    src: url('./${rel_font_path}') format('truetype');
    font-weight: normal;
    font-style: normal;
}
body, code, pre {
    font-family: 'Cascadia Code', monospace;
}
EOF

# Generate or update main.css to import cascadia-code.css
if ! grep -q "@import.*cascadia-code.css" "$MAIN_CSS" 2>/dev/null; then
    echo "@import url('cascadia-code/cascadia-code.css');" >>"$MAIN_CSS"
fi

# Clean up
echo "Cascadia Code font installed in $FONT_DIR. CSS generated."
