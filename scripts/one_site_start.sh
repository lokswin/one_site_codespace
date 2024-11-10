#!/bin/sh
# scripts/one_site_start.sh

# Load environment variables from secrets
export GUAC_USER=${GUAC_USER}
export GUAC_PASS=${GUAC_PASS}
export TOTP_SECRET_KEY=${TOTP_SECRET_KEY}
export VNC_HOSTNAME=${VNC_HOSTNAME}
export VNC_PORT=${VNC_PORT}
export GUACD_HOSTNAME=${GUACD_HOSTNAME}
export GUACD_PORT=${GUACD_PORT}
export DISPLAY=${DISPLAY:-:15}

# Load debug flag from secrets, default to false if not set
export DEBUG_ALL=${DEBUG_ALL:-false}

# Function to check if debug mode is on
debug_log() {
    if [ "$DEBUG_ALL" = "true" ]; then
        echo "[DEBUG] $1"
    fi
}

# Function to start a service if it's not running and log for debugging
start_service() {
    command -v "$2" >/dev/null 2>&1 || { echo "[ERROR] $2 command not found"; exit 1; }
    
    if ! pgrep "$1" > /dev/null; then
        if [ "$DEBUG_ALL" = "true" ]; then
            debug_log "Starting $1 with debug options"
            "$2" & # Run with debug options if available
        else
            "$2" & # Regular start
        fi
        echo "$1 started"
    else
        debug_log "$1 is already running"
    fi
}

# Start services with debug options if enabled
debug_log "Starting services with DISPLAY set to $DISPLAY"

start_service "Xvfb" "Xvfb $DISPLAY -screen 0 1920x1080x24 $(if [ "$DEBUG_ALL" = "true" ]; then echo '-audit 4'; fi)"
start_service "x11vnc" "x11vnc -forever -usepw -display $DISPLAY -rfbport ${VNC_PORT:-5901} $(if [ "$DEBUG_ALL" = "true" ]; then echo '-debug'; fi)"
start_service "fluxbox" "DISPLAY=$DISPLAY fluxbox $(if [ "$DEBUG_ALL" = "true" ]; then echo '-log ~/.fluxbox/debug.log'; fi)"
start_service "firefox" "DISPLAY=$DISPLAY firefox-esr $(if [ "$DEBUG_ALL" = "true" ]; then echo '--debug'; fi)"
start_service "guacd" "guacd $(if [ "$DEBUG_ALL" = "true" ]; then echo '-L debug'; fi)"
start_service "catalina.sh" "/usr/local/tomcat/bin/catalina.sh run $(if [ "$DEBUG_ALL" = "true" ]; then echo '-verbose:class'; fi)"

# Keep container running
exec "$@"
