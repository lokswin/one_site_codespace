# Use the official Alpine Linux base image
FROM alpine:3.20

# Add a non-root user for running the container
#RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install necessary packages
RUN apk update && \
    apk add --no-cache \
        openbox \
        xorg-server \
        xauth \
        xterm \
        ttf-dejavu \
        wget \
        curl \
        libx11 \
        libxrender \
        libxext \
        libxrandr \
        libxcb \
        mesa-gl \
        glib \
        gtk+3.0 \
    && rm -rf /var/cache/apk/*

RUN apk update && \
    apk add --no-cache \
        firefox-esr \
        x11vnc \
        xvfb \
        dbus \
        dbus-x11 \
        libressl \
        ca-certificates \
        bash \
    && rm -rf /var/cache/apk/*


RUN mkdir -p /var/run/dbus && chmod 755 /var/run/dbus

RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Set environment variables
ENV DISPLAY=:35
ENV VNC_PASSWORD=
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/var/run/dbus/system_bus_socket
# Use Tini as the entrypoint for proper signal handling
#ENTRYPOINT ["/sbin/tini", "--"]

# Start dbus, Xvfb, openbox, x11vnc, and Chromium
#       VNC_PASSWORD=$(cat /run/secrets/vnc_password) && \
ENTRYPOINT ["/bin/ash", "-c", "\
    dbus-daemon --system --fork; \
    date; \
    update-ca-certificates; \
    ls /tmp/.X11-unix/; \
    if [ -f \"/tmp/.X${DISPLAY}-lock\" ]; then \
        rm -f \"/tmp/.X${DISPLAY}-lock\"; \
        echo 'Deleted display lock for ${DISPLAY}'; \
    else \
        echo 'No display lock to delete for ${DISPLAY}'; \
    fi; \
    Xvfb $DISPLAY -screen 0 ${DESKTOP_RESOLUTION:-1920x1280x24} & \
    xvfb_pid=$!; \
    x11vnc -storepasswd $VNC_PASSWORD /root/passwd; \
    x11vnc -display $DISPLAY -forever -rfbauth /root/passwd -listen 0.0.0.0 & \
    x11vnc_pid=$!; \
    openbox & \
    winman_pid=$!; \
    dbus-launch firefox-esr & \
    brow_pid=$!; \
    wait $xvfb_pid $winman_pid $x11vnc_pid $brow_pid; \
"]
