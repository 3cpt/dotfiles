# Use the official Debian image from the Docker Hub
FROM debian:bookworm-slim

# Install sudo and other necessary packages
RUN apt-get update && apt-get install -y sudo curl unzip

# Create a new user 'my' and add it to the sudo group
RUN useradd -m -s /bin/bash my && \
    echo 'my:p' | chpasswd && \
    usermod -aG sudo my

# Allow 'my' to use sudo without a password (optional)
RUN echo 'my ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the user to 'my'
USER my

# Copy content of this repo to the container HOME directory of the user 'my'
COPY --chown=my:my . /home/my/dotfiles

# Set the working directory of the user 'my'
WORKDIR /home/my/dotfiles

# Start an interactive terminal
CMD ["bash"]
