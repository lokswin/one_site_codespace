#!/bin/bash

# ./scripts/entrypoint.sh
# This script is executed when the Docker container starts.
# It sets up the environment, starts necessary services, and launches qutebrowser.

# Exit on error
set -e

# Ensure log directory exists
mkdir -p /var/log

# Start Xvfb and redirect output to log file
Xvfb :0 -screen 0 1024x768x16 -ac -nolisten tcp > /var/log/xvfb.log 2>&1 &

# Wait for Xvfb to start
sleep 5

# Start qutebrowser and redirect output to log file
qutebrowser https://www.example.com --backend webengine > /var/log/qutebrowser.log 2>&1 &

# Wait for qutebrowser to start
sleep 5

# Start x11vnc and redirect output to log file
x11vnc -auth /tmp/.Xauthority -rfbauth /opt/noVNC/passwd -display :0 -forever -loop -rfbport 5900 -shared > /var/log/x11vnc.log 2>&1 &

# Start noVNC proxy and redirect output to log file
/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 > /var/log/novnc.log 2>&1 &

# Wait and keep the container running
wait
