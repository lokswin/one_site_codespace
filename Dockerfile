# Use an official lightweight base image
FROM alpine:3.20

# Enable debugging with an ARG
ARG DEBUG=true

# Update and install necessary packages
RUN apk update && apk add --no-cache \
    firefox \
    xvfb \
    x11vnc \
    fluxbox \
    xauth \
    x11-xserver-utils \
    bash \
    net-tools \
    lsof \
    grep \
    tini \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/*

RUN echo "${X11VNC_PASSWORD}" | x11vnc -storepasswd - /etc/x11vnc.pass

# Expose necessary ports for VNC and Web access
EXPOSE 5901 6080

# Create startup script for VNC and Xvfb
COPY ./scripts/one_site_start.sh /usr/local/bin/one_site_start.sh
RUN chmod +x /usr/local/bin/one_site_start.sh

# Use tini as the entrypoint for proper PID 1 handling
ENTRYPOINT ["/sbin/tini", "--"]

# Start the container with the custom script
CMD ["/usr/local/bin/one_site_start.sh"]
