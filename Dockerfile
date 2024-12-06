# Use the official Alpine Linux base image
FROM alpine:3.20
# Install necessary packages
RUN apk update && \
    apk add --no-cache \
        firefox-esr \
        x11vnc \
        xvfb \
        fluxbox \
        ttf-dejavu \
        dbus \
        bash \
        msttcorefonts-installer && \
    update-ms-fonts && \
    fc-cache -f


# Start the VNC server and Firefox when the container launches
CMD ["bash", "-c", "Xvfb :15 -screen 0 1024x768x16 & \
                  fluxbox & \
                  x11vnc -display :15 -forever -nopw -listen 0.0.0.0 & \
                  dbus-launch firefox"]

