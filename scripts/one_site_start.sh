#!/bin/bash

# Check if Xvfb is running on the display port
if ! pgrep Xvfb; then
  Xvfb :$PORT -screen 0 1920x1080x24 &
  echo "Xvfb started on display :$PORT"
fi

# Start x11vnc server
if ! pgrep x11vnc; then
  x11vnc -forever -usepw -display :$PORT -rfbport 5901 &
  echo "x11vnc started on display :$PORT"
fi

# Start Firefox and Fluxbox
if ! pgrep fluxbox; then
  DISPLAY=:$PORT fluxbox &
  echo "Fluxbox started"
fi

if ! pgrep firefox; then
  DISPLAY=:$PORT firefox &
  echo "Firefox started"
fi

# Start Guacamole daemon and Tomcat
if ! pgrep guacd; then
  guacd &
  echo "Guacamole daemon started"
fi

if ! systemctl is-active --quiet tomcat9; then
  systemctl start tomcat9
  echo "Tomcat started"
fi
