#!/bin/sh

start_service() {
  if ! pgrep "$1"; then
    "$2" &
    echo "$1 started"
  fi
}

export DISPLAY=${DISPLAY:-:15}

# Start Xvfb, x11vnc, Fluxbox, Firefox, Guacamole daemon, and Tomcat
start_service "Xvfb" "Xvfb $DISPLAY -screen 0 1920x1080x24"
start_service "x11vnc" "x11vnc -forever -usepw -display $DISPLAY -rfbport 5901"
start_service "fluxbox" "DISPLAY=$DISPLAY fluxbox"
start_service "firefox" "DISPLAY=$DISPLAY firefox-esr"
start_service "guacd" "guacd"
start_service "catalina.sh" "/usr/local/tomcat/bin/catalina.sh run"
