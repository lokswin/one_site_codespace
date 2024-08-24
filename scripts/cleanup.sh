#!/bin/bash

# ./scripts/cleanup.sh
# This script removes unnecessary files and reduces the Docker image size.
# It is executed after the container is set up to clean up temporary files and packages.

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting cleanup process..."

# Stop and disable services that are no longer needed
echo "Stopping unnecessary services..."
systemctl stop apt-daily.timer
systemctl disable apt-daily.timer
systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer

# Remove unnecessary packages
echo "Removing unnecessary packages..."
apt-get remove --purge -y \
    git \
    python3 \
    python3-pip \
    gcc \
    make \
    build-essential \
    && apt-get autoremove -y && apt-get clean

# Remove leftover directories and files from package installations
echo "Cleaning up package caches and temporary files..."
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/info/*

# Remove unnecessary files related to git and python
echo "Removing unnecessary git and python files..."
rm -rf /opt/noVNC/.git
rm -rf /opt/noVNC/utils/websockify/.git
rm -rf /usr/lib/python*/test
rm -rf /usr/lib/python*/distutils
rm -rf /usr/lib/python*/ensurepip

# Reduce size by removing build tools and documentation
echo "Removing build tools and documentation..."
apt-get remove --purge -y \
    manpages \
    man-db \
    && apt-get autoremove -y && apt-get clean

# Remove history files to reduce image size further
echo "Clearing bash history..."
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/devuser/.bash_history

# Final cleanup of devcontainer and Dockerfile caches
echo "Final cleanup..."
rm -rf /root/.cache/*
rm -rf /home/devuser/.cache/*
rm -rf /root/.local/share/*
rm -rf /home/devuser/.local/share/*

# Remove the cleanup script itself
echo "Removing cleanup script..."
rm -- "$0"

echo "Cleanup process completed successfully!"
