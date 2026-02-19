#!/bin/bash

echo "Fetching the latest release data from GitHub CLI releases..."

# Fetch the latest release data from GitHub CLI releases
release_data=$(curl -s https://api.github.com/repos/cli/cli/releases/latest)

# Determine the architecture of the machine
arch=$(uname -m)

if [[ "$arch" == "x86_64" ]]; then
    arch="amd64"
elif [[ "$arch" == "aarch64" ]]; then
    arch="arm64"
elif [[ "$arch" == "armv7l" ]]; then
    arch="armv7"
elif [[ "$arch" == "arm64" ]]; then
    arch="arm64"
else
    echo "Unsupported architecture: $arch"
    exit 1
fi

OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    if command -v brew >/dev/null 2>&1; then
        echo "Installing GitHub CLI via Homebrew..."
        brew install gh
        echo "GitHub CLI installed successfully!"
        exit 0
    else
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
fi

extension="deb"

echo "System architecture determined: $arch"

# Find the appropriate asset URLs
echo "Finding the appropriate asset URLs..."
checksum_url=$(echo "$release_data" | grep "browser_download_url.*checksums.txt" | cut -d '"' -f 4)
deb_url=$(echo "$release_data" | grep "browser_download_url.*${arch}.${extension}" | cut -d '"' -f 4)

echo "Checksum URL: $checksum_url"
echo "Deb URL: $deb_url"

# Download the .deb file and the checksum file
echo "Downloading the .${extension} file and checksum file..."
curl -L -o gh_cli.${extension} "$deb_url"
curl -L -o checksums.txt "$checksum_url"

# Verify that the files were downloaded successfully
if [[ ! -f "gh_cli.${extension}" || ! -f "checksums.txt" ]]; then
    echo "Download failed. Exiting."
    exit 1
fi

# Extract the downloaded file's checksum
checksum_file=$(basename "$deb_url")
echo "Looking for the checksum of the file: $checksum_file"
expected_checksum=$(grep "$checksum_file" checksums.txt | awk '{print $1}')

# Calculate the actual checksum of the downloaded file
echo "Calculating the checksum of the downloaded file..."
actual_checksum=$(sha256sum gh_cli.${extension} | awk '{print $1}')

echo "Expected checksum: $expected_checksum"
echo "Actual checksum: $actual_checksum"

# Verify the checksum
if [[ "$expected_checksum" != "$actual_checksum" ]]; then
    echo "Checksum verification failed! Exiting."
    rm gh_cli.${extension} checksums.txt
    exit 1
fi

# Install the package using dpkg
echo "Installing the package using dpkg..."
sudo dpkg -i gh_cli.${extension}

# Clean up the downloaded files
echo "Cleaning up the downloaded files..."
rm gh_cli.${extension} checksums.txt

echo "GitHub CLI installed successfully!"
