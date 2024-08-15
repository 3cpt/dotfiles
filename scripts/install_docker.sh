#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to detect the distribution and set the appropriate Docker repository URL
set_docker_repo() {
    source /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        DOCKER_URL="https://download.docker.com/linux/ubuntu"
    elif [ "$ID" == "debian" ]; then
        DOCKER_URL="https://download.docker.com/linux/debian"
    else
        echo "Unsupported distribution: $ID"
        exit 1
    fi
}

sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Set up the Docker GPG key and apt repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "$DOCKER_URL/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] $DOCKER_URL \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Update the package list to include Docker packages
sudo apt-get update

# Install Docker Engine, CLI, and necessary plugins
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create Docker group and add the current user to it
sudo groupadd docker
sudo usermod -aG docker $USER

# Notify the user to log out and log back in or use newgrp
echo "Docker installation complete! Log out and back in, or run 'newgrp docker' to apply group changes."

# Optional: Run newgrp docker to avoid logging out (uncomment if desired)
# newgrp docker

# Verify that Docker can be run without sudo
docker run hello-world
