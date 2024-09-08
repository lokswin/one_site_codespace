#!/bin/sh

# Set up logging
mkdir -p /var/log/vnc
LOG_FILE="/var/log/vnc/x11vnc2.log"

# Redirect stdout and stderr to the log file
exec > "$LOG_FILE" 2>&1
echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Script started."

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" >> "$LOG_FILE"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" >> "$LOG_FILE"
}

# Check for x11vnc command
if ! command -v x11vnc >/dev/null 2>&1; then
    log_error "x11vnc is not installed. Aborting."
    exit 1
fi

log_message "Starting x11vnc..."
x11vnc -noxdamage -ncache 10 -display :1 -nopw -forever -shared -logfile "$LOG_FILE" &

# Allow time for the x11vnc server to start
sleep 5

# Check for novnc command
log_message "Starting noVNC client..."
/usr/bin/websockify --web /usr/share/novnc 6080 localhost:5901  &
sleep 5

if ps -p $! > /dev/null; then
    log_message "noVNC client started successfully."
else
    log_error "Failed to start noVNC client."
    exit 1
fi

mkdir -p /var/log/vnc
export XDG_RUNTIME_DIR=/tmp/runtime-$(whoami)
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

DISPLAY=:1 qutebrowser --temp-basedir https://www.google.com --backend webengine --target=window --debug --qt-flag no-sandbox > /var/log/vnc/qutebrowser.log 2>&1 &
# DISPLAY=:1 qutebrowser https://www.google.com --backend webengine --target=window --config-py=/opt/config.py --debug > /var/log/vnc/qutebrowser.log 2>&1 &


log_message "VNC server and noVNC client running. Monitoring processes..."
wait

log_message "One of the VNC processes has terminated. Exiting..."
exit 0
