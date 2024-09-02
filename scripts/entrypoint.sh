#!/bin/bash
# file:./scripts/entrypoint.sh
# This script is executed when the Docker container starts.
# It sets up the environment, starts necessary services, and launches qutebrowser.

# Exit on error
set -e

# Ensure log directory exists
mkdir -p $LOG_ONE_PATH
mkdir -p /tmp/runtime && chmod 700 /tmp/runtime && \

# Create .Xauthority file for X11 authentication
$HOME/create_xauthority.sh

# Start Xvfb and redirect output to log file
Xvfb :0 -screen 0 1024x768x16 -ac -nolisten tcp -audit 4 > $LOG_ONE_PATH/xvfb.log 2>&1 &


# Wait for Xvfb to start
sleep 3


# Start qutebrowser with --no-sandbox flag and redirect output to log file
DISPLAY=:0 qutebrowser https://www.google.com --backend webengine --target=window --config-py=$HOME/config.py --debug > $LOG_ONE_PATH/qutebrowser.log 2>&1 &
# Wait for qutebrowser to start
sleep 3

# Start x11vnc and redirect output to log file
#x11vnc -auth /tmp/.Xauthority -rfbauth /opt/noVNC/passwd -display :0 -forever -loop -rfbport 5900 -shared > $LOG_ONE_PATH/x11vnc.log 2>&1 &
# Start x11vnc using your script and redirect output to log file
#$HOME/mtu.sh


$HOME/x11vnc.sh

$HOME/startVNCClient.sh

wait
#$HOME/cleanup.sh