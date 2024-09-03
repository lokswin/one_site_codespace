#!/bin/sh

# Set up logging
mkdir -p $LOG_ONE_PATH
LOG_FILE="$LOG_ONE_PATH/x11vnc.log"

# Redirect stdout and stderr to the log file
exec > "$LOG_FILE" 2>&1
echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Script started."

# Initialize DEBUG variable
DEBUG=1

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" >> "$LOG_FILE"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" >> "$LOG_FILE"
}


# Check for novnc command
if ! command -v novnc >/dev/null 2>&1; then
    log_error "noVNC is not installed or not in PATH. Aborting."
    #exit 1
fi
# Check if port 6080 is already in use
if lsof -i:6080 >/dev/null 2>&1; then
    log_error "Port 6080 is already in use. Aborting."
    #exit 1
fi

# Check for x11vnc command
if ! command -v x11vnc >/dev/null 2>&1; then
    log_error "x11vnc is not installed. Aborting."
    exit 1
fi

# Determine the current UID and user
CURRENT_UID=$(id -u "$USERNAME")
if [ "$CURRENT_UID" -eq 0 ]; then
    if ! GDM_UID=$(id -u gdm 2>/dev/null); then
        log_error "Failed to determine gdm UID."
        exit 1
    fi
    log_message "x11vnc found UID==0; forcing gdm UID ${GDM_UID} ..."
    CURRENT_UID="$GDM_UID"
fi

AUTH_COOKIE=$XAUTH_FILE
AUTH_FILE=$VNC_AUTH_FILE

CURRENT_USER="$USER"
if [ -z "$CURRENT_USER" ]; then
    CURRENT_USER=$(getent passwd "$CURRENT_UID" | awk -F: '{ print $1 }') || {
        log_error "Failed to resolve username for UID ${CURRENT_UID}."
        exit 1
    }
fi

log_message "Starting x11vnc for user $CURRENT_USER (uid $CURRENT_UID)."
log_message "Logging to $LOG_FILE."

# Check if x11vnc is already running
if pgrep -f "^[x]11vnc" --euid "$CURRENT_UID" >/dev/null; then
    log_error "x11vnc appears to be running already for UID $CURRENT_UID."
    exit 1
fi

DISP_ARG="-display $DISPLAY"
if [ -z "$DISPLAY" ]; then
    log_message "x11vnc could not detect display; using -find instead"
    DISP_ARG="-find"
fi

if [ ! -e "$AUTH_COOKIE" ]; then
    log_error "Could not find auth file."
    exit 2
fi

PW_OPT=""
if [ -e "$AUTH_FILE" ]; then
    PW_OPT="-rfbauth $AUTH_FILE"
    log_message "x11vnc using authentication file $AUTH_FILE."
fi

# Start x11vnc with appropriate arguments
VNC_CMD="x11vnc -bg $DISP_ARG $PW_OPT"
log_message "Executing command: ${VNC_CMD} -auth \"$AUTH_COOKIE\" -logfile \"$LOG_FILE\" -forever -noxdamage"
${VNC_CMD} -auth "$AUTH_COOKIE" \
           -logfile "$LOG_FILE" \
           -forever \
           -noxdamage &

# Allow time for the x11vnc server to start
sleep 5

VNC_PID=$(pgrep -f "^[x]11vnc" --euid "$CURRENT_UID")
if [ -z "$VNC_PID" ]; then
    log_error "x11vnc failed to start."
    exit 3
else
    log_message "Detected x11vnc running on pid $VNC_PID, waiting for socket..."
fi

# Start noVNC client
log_message "Starting noVNC client..."
NOVNC_CMD="novnc --listen 6080 --vnc localhost:5900"

$NOVNC_CMD >> "$LOG_FILE" 2>&1 &
NOVNC_PID=$!


# if [ ! -f /opt/noVNC/utils/launch.sh ]; then
#     log_error "noVNC launch script not found at /opt/noVNC/utils/launch.sh. Exiting..."
#     exit 1
# fi
#/opt/noVNC/utils/launch.sh --vnc localhost:5900 --listen 6080 &
#NOVNC_PID=$!
sleep 5

if ps -p $NOVNC_PID >/dev/null; then
    log_message "noVNC client started successfully with PID $NOVNC_PID."
else
    log_error "Failed to start noVNC client."
    exit 1
fi

log_message "VNC server and noVNC client running. Monitoring processes..."
wait -n

log_message "One of the VNC processes has terminated. Exiting..."
exit 0
