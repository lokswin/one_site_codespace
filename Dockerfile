# Use an Ubuntu base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    x11vnc \
    xvfb \
    supervisor \
    wget \
    fluxbox \
    net-tools \
    openssl \
    novnc

RUN apt-get install -y qutebrowser

# Set environment variables
ENV DISPLAY=:1

# Create directories and download necessary components
RUN mkdir -p /opt/novnc && \
    mkdir -p /opt/websockify && \
    mkdir -p /etc/supervisor/conf.d && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz -O /opt/novnc.tar.gz && \
    tar xzf /opt/novnc.tar.gz -C /opt/novnc --strip-components=1 && \
    rm /opt/novnc.tar.gz && \
    wget https://github.com/novnc/websockify/archive/refs/tags/v0.10.0.tar.gz -O /opt/websockify.tar.gz && \
    tar xzf /opt/websockify.tar.gz -C /opt/websockify --strip-components=1 && \
    rm /opt/websockify.tar.gz

# Add files
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./config/config.py /opt/config.py
COPY ./scripts/entrypoint.sh /opt/entrypoint.sh
COPY ./scripts/create_xauthority.sh /opt/create_xauthority.sh
COPY ./scripts/vnc_launch.sh /opt/vnc_launch.sh


# Make scripts executable
RUN chmod +x /opt/entrypoint.sh /opt/create_xauthority.sh /opt/vnc_launch.sh

# Expose the VNC and noVNC ports
EXPOSE 5901 6080

# Set the entrypoint
ENTRYPOINT ["/opt/entrypoint.sh"]
