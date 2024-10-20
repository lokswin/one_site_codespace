#!/bin/bash

if [ "$DEBUG" = true ]; then
  set -x
fi

# Check if Xvfb is running on the display port
if ps aux | grep "[X]vfb :$PORT"; then
  echo "Xvfb is already running on display :$PORT."
  exit 1
else
  echo "Display :$PORT is free."
fi

# Start virtual framebuffer on a free display port
Xvfb :$PORT -screen 0 1920x1080x24 &
sleep 2  # Give it time to start
if ps aux | grep Xvfb; then
  echo "Xvfb is running on display :$PORT"
else
  echo "Failed to start Xvfb on display :$PORT"
  exit 1
fi

# Start VNC server with password
x11vnc -forever -usepw -display :$PORT -unixpw_maxtries 5 -unixpw_maxbad 5h &
sleep 2
if ps aux | grep x11vnc; then
  echo "x11vnc started on display :$PORT"
else
  echo "Failed to start x11vnc."
  exit 1
fi

# Start Firefox browser
DISPLAY=:$PORT fluxbox &
DISPLAY=:$PORT firefox &

# Start Guacamole daemon
guacd &
if ps aux | grep guacd; then
  echo "guacd started successfully"
else
  echo "Failed to start guacd"
  exit 1
fi

# Start Tomcat for Guacamole client
systemctl start tomcat9
if systemctl status tomcat9 | grep running; then
  echo "Tomcat started successfully"
else
  echo "Failed to start Tomcat"
  exit 1
fi
