# Use an official lightweight base image
FROM ubuntu:20.04

# Set environment variables to avoid user prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Enable debugging with an ARG
ARG DEBUG=false# Setup password from GitHub secrets
ARG X11VNC_PASSWORD

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    fluxbox \
    x11-xserver-utils \
    x11-utils \
    net-tools \
    lsof \
    firefox \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "${X11VNC_PASSWORD}" | x11vnc -storepasswd - /etc/x11vnc.pass

# Expose necessary ports for VNC and Web access
EXPOSE 5901 6080

# Create startup script for VNC and Xvfb
COPY scripts/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Entry point
ENTRYPOINT ["/usr/local/bin/start.sh"]

# Clean up unnecessary files to reduce container size
RUN apt-get remove --purge -y && \
    rm -rf /var/cache/*
