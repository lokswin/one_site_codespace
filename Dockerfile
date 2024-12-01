# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:15
ENV VNC_PORT=5900

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        firefox \
        x11vnc \
        xvfb \
        x11-utils \
        x11-xserver-utils \
        lsof \
        netstat \
        fluxbox && \
    rm -rf /var/lib/apt/lists/*

# Expose VNC port internally (no need to expose it to the host)
EXPOSE $VNC_PORT

# Start the VNC server and Firefox when the container launches
CMD ["bash", "-c", "Xvfb :15 -screen 0 1024x768x16 & fluxbox & x11vnc -display :15 -forever -nopw -listen 0.0.0.0 & firefox"]
