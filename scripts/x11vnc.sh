#!/bin/bash
# file: ./scripts/x11vnc.sh
#
# script for starting x11vnc on the current display
# uses the GDM login cookie to connect to X server
#
# note: requires a password be configured and stored
# the normal password file is usually ~/.vnc/passwd
# to configure a password, run:
#   `x11vnc -storepasswd`

mkdir -p $LOG_ONE_PATH
LOG_FILE="$LOG_ONE_PATH/x11vnc.log"
# Initialize DEBUG variable
DEBUG=1

# Check for x11vnc command
hash x11vnc 2>/dev/null || { echo >&2 "You need to install x11vnc. Aborting."; exit 1; }

# Determine the current UID and user
CURRENT_UID=$(id -u "$USERNAME")
if [[ $CURRENT_UID == 0 ]]; then
  if ! GDM_UID=$(id -u gdm); then
    logger -p syslog.error "ERROR: Failed to determine gdm UID."
    echo >&2 "ERROR: Failed to determine gdm UID."
    exit 1
  fi
  logger -p syslog.warn "WARNING: x11vnc found UID==0; forcing gdm UID ${GDM_UID} ..."
  echo >&2 "WARNING: x11vnc found UID==0; forcing gdm UID ${GDM_UID} ..."
  CURRENT_UID="${GDM_UID}"
fi

AUTH_COOKIE=$XAUTH_FILE
AUTH_FILE=$VNC_AUTH_FILE

CURRENT_USER="$USER"
if [[ -z "$CURRENT_USER" ]]; then
  if ! CURRENT_USER=$(getent passwd "$CURRENT_UID" | awk -F: '{ print $1 }'); then
    logger -p syslog.warn "WARNING: Failed to resolve username for UID ${CURRENT_UID}."
    echo >&2 "WARNING: Failed to resolve username for UID ${CURRENT_UID}."
  fi
fi
if [[ -z "$CURRENT_USER" ]]; then
  logger -p syslog.error "ERROR: x11vnc could not identify the user to run under."
  echo >&2 "ERROR: x11vnc could not identify the user to run under."
  exit 1
fi

logger -p syslog.info "Starting x11vnc for user $CURRENT_USER (uid $CURRENT_UID) ..."
logger -p syslog.info "Logging to $LOG_FILE"

echo "INFO: Starting x11vnc for user $CURRENT_USER (uid $CURRENT_UID) ..."
echo "INFO: Logging to $LOG_FILE"

# Check if x11vnc is already running
VNC_PID=$(pgrep -f "^[x]11vnc" --euid "$CURRENT_UID")
if [[ -n "$VNC_PID" ]]; then
  logger -p syslog.error "ERROR: x11vnc appears to be running already for UID $CURRENT_UID (pid $VNC_PID)."
  echo >&2 "ERROR: x11vnc appears to be running already for UID $CURRENT_UID (pid $VNC_PID)."
  exit 1
fi

DISP_ARG="-display $DISPLAY"
if [[ -z "$DISPLAY" ]]; then
  logger -p syslog.warn "WARNING: x11vnc could not detect display; using -find instead"
  echo >&2 "WARNING: x11vnc could not detect display; using -find instead"
  DISP_ARG="-find"
fi

if [[ ! -e "$AUTH_COOKIE" ]]; then
  logger -p syslog.error "ERROR: Could not find auth file."
  echo >&2 "ERROR: Could not find auth file."
  exit 2
fi

PW_OPT=""
#if [[ -e /etc/x11vnc.pass ]]; then
if [[ -e "$AUTH_FILE" ]]; then
  PW_OPT="-rfbauth $AUTH_FILE"
  logger -p syslog.info "INFO: x11vnc using authentication file $AUTH_FILE"
  echo "INFO: x11vnc using authentication file $AUTH_FILE"
fi

# Note: use -logappend for persistent logging
VNC_CMD="x11vnc -bg $DISP_ARG -usepw $PW_OPT"
if [[ "$DEBUG" == 1 ]]; then
  logger -p syslog.info "DEBUG: Executing command: ${VNC_CMD} -auth \"$AUTH_COOKIE\" -logfile \"$LOG_FILE\" -forever -noxdamage"
fi
${VNC_CMD} -auth "$AUTH_COOKIE" \
           -logfile "$LOG_FILE" \
           -forever \
           -noxdamage > /dev/null 2>&1 &

# Give the socket a moment to bind
sleep 3

VNC_PID=$(pgrep -f "^[x]11vnc" --euid "$CURRENT_UID")
if [[ -z "$VNC_PID" ]]; then
  logger -p syslog.error "ERROR: x11vnc failed to start."
  echo >&2 "ERROR: x11vnc failed to start."
  exit 3
else
  logger -p syslog.info "INFO: Detected x11vnc running on pid $VNC_PID, waiting for socket..."
  echo "INFO: Detected x11vnc running on pid $VNC_PID, waiting for socket..."
fi

# Get the port number
# PORT=""
# if [[ "$HAS_NETCAT" == "true" ]]; then
#   PORT=$(netstat -4 -an --tcp --program 2> /dev/null | grep "$VNC_PID" | awk '{print $4}' | awk -F":" '{print $2}' | head -n1)
# else
#   PORT=$(lsof -nPi | grep "IPv4" | grep "$VNC_PID" | awk '{print $9}' | awk -F":" '{print $2}' | head -n1)
# fi

# DEBUG: log all ports visible at this point in the script
if [[ "$DEBUG" == 1 ]]; then
  TEST=$(netstat -4 -an --tcp --program)
  logger -p syslog.debug "DEBUG: x11vnc is able to see the following ports: $TEST"
fi

# Check if we were able to find the listen port, and if so, validate it
re='^[0-9]+$'
if ! [[ $PORT =~ $re ]] ; then
  if ! [[ -z $PORT ]]; then
    logger -p syslog.error "ERROR: '$PORT' is not a valid x11vnc port number."
    echo >&2 "ERROR: '$PORT' is not a valid x11vnc port number."
    exit 4
  else
    # Port is null but x11vnc is running
    PORT="?"
    logger -p syslog.warn "WARNING: Unable to determine which port x11vnc is listening on."
    echo >&2 "WARNING: Unable to determine which port x11vnc is listening on."
  fi
fi

echo "INFO: Found open x11vnc socket on port ${PORT}/tcp"

display_string="display ${DISPLAY}"
if [ -z "${DISPLAY}" ]; then
  echo >&2 "WARNING: Unable to determine display."
  display_string="unknown display"
fi

logger -p syslog.info "x11vnc started on display $DISPLAY; listening on 127.0.0.1:$PORT"
echo "INFO: x11vnc started on $display_string; listening on 127.0.0.1:$PORT"

exit 0