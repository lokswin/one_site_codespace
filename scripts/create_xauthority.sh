#!/bin/bash
# file: ./scripts/create_xauthority.sh

log_message() {
    echo "[INFO] $1"
}

log_message "Creating Xauthority file..."
xauth generate $DISPLAY . trusted
xauth add $DISPLAY . $(mcookie)

if [ -f $XAUTHORITY ]; then
    log_message "Xauthority file created successfully."
else
    log_message "[ERROR] Failed to create Xauthority file. Exiting..."
    exit 1
fi
