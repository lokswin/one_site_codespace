#!/bin/bash

# ./scripts/cleanup.sh
# This script removes unnecessary files and reduces the Docker image size.
# It is executed after the container is set up to clean up temporary files and packages.

#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting cleanup process..."


# Remove unnecessary packages
apt-get remove --purge -y \
    git \
    python3 \
    python3-pip \
    gcc \
    make \
    build-essential \
    && apt-get autoremove -y && apt-get clean

# Clean up package caches and temporary files
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/info/*

# Remove unnecessary files related to git and python
rm -rf /opt/noVNC/.git
rm -rf /opt/noVNC/utils/websockify/.git
rm -rf /usr/lib/python*/test
rm -rf /usr/lib/python*/distutils
rm -rf /usr/lib/python*/ensurepip

# Remove build tools and documentation
apt-get remove --purge -y manpages man-db && apt-get autoremove -y && apt-get clean

# Clear bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/devuser/.bash_history

# Final cleanup of devcontainer and Dockerfile caches
rm -rf /root/.cache/*
rm -rf /home/devuser/.cache/*
rm -rf /root/.local/share/*
rm -rf /home/devuser/.local/share/*
rm -rf $HOME/.local/share/*
rm -rf $HOME/devuser/.local/share/*


# Remove the cleanup script itself
rm -- "$0"

echo "Cleanup process completed successfully!"
