#!/bin/bash
# file:./scripts/entrypoint.sh
# This script is executed when the Docker container starts.
# It sets up the environment, starts necessary services, and launches qutebrowser.

# Exit on error
set -e

# Ensure log directory exists
mkdir -p /var/log/onepage-browser-container

# Start Xvfb and redirect output to log file
Xvfb :0 -screen 0 1024x768x16 -ac -nolisten tcp > /var/log/onepage-browser-container/xvfb.log 2>&1 &

# Wait for Xvfb to start
sleep 5

# Start qutebrowser with --no-sandbox flag and redirect output to log file
qutebrowser https://www.example.com --backend webengine > /var/log/onepage-browser-container/qutebrowser.log 2>&1 &
# Wait for qutebrowser to start
sleep 5

# Start x11vnc and redirect output to log file
#x11vnc -auth /tmp/.Xauthority -rfbauth /opt/noVNC/passwd -display :0 -forever -loop -rfbport 5900 -shared > /var/log/onepage-browser-container/x11vnc.log 2>&1 &
# Start x11vnc using your script and redirect output to log file
/usr/local/bin/x11vnc.sh

/usr/local/bin/startVNCClient.sh

/usr/local/bin/cleanup.sh