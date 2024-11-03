#!/bin/sh
# scripts/one_site_start.sh
export GUAC_USER=${GUAC_USER}
export GUAC_PASS=${GUAC_PASS}
export TOTP_SECRET_KEY=${TOTP_SECRET_KEY}
export VNC_HOSTNAME=${VNC_HOSTNAME}
export VNC_PORT=${VNC_PORT}

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
