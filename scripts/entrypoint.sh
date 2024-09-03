#!/bin/bash
# file: ./scripts/entrypoint.sh
# This script is executed when the Docker container starts.
# It sets up the environment, starts necessary services, and launches noVNC.

#!/bin/sh
set -e

# Function to log messages
log_message() {
    echo "[INFO] $1"
}

# Step 1: Environment Setup
log_message "Step 1: Setting up environment variables..."
export DISPLAY=:1
export XAUTHORITY=/root/.Xauthority

# Step 2: Start Xvfb
log_message "Step 2: Starting Xvfb (X virtual framebuffer)..."
/usr/bin/Xvfb $DISPLAY -screen 0 1024x768x16 &
XVFB_PID=$!
sleep 5

if ps -p $XVFB_PID > /dev/null; then
    log_message "Xvfb started successfully with PID $XVFB_PID."
else
    log_message "[ERROR] Failed to start Xvfb. Exiting..."
    exit 1
fi

# Step 3: Xauthority Creation
log_message "Step 3: Checking if Xauthority file exists..."
if [ ! -f $XAUTHORITY ]; then
    log_message "Xauthority file not found. Creating Xauthority..."
    /opt/create_xauthority.sh

    if [ -f $XAUTHORITY ]; then
        log_message "Xauthority file created successfully."
    else
        log_message "[ERROR] Failed to create Xauthority file. Exiting..."
        exit 1
    fi
else
    log_message "Xauthority file already exists."
fi

# Step 4: Start VNC Server and noVNC client
log_message "Step 4: Starting VNC server and noVNC client..."
/opt/vnc_launch.sh &
VNC_LAUNCH_PID=$!
sleep 5

if ps -p $VNC_LAUNCH_PID > /dev/null; then
    log_message "VNC server and noVNC client started successfully with PID $VNC_LAUNCH_PID."
else
    log_message "[ERROR] Failed to start VNC server and noVNC client. Exiting..."
    exit 1
fi

# Step 5: Monitor Processes
log_message "Step 5: Monitoring processes..."
wait -n

log_message "[INFO] One of the background processes has terminated. Exiting..."
exit $?
