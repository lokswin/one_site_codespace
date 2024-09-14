# Use an official lightweight base image
FROM ubuntu:20.04

# Set environment variables to avoid user prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages: 
# - xpra: for remote desktop over HTML5
# - xvfb: virtual display
# - fluxbox: lightweight window manager
# - firefox: lightweight browser
# - wget, apt-utils, python3: utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    xpra \
    xvfb \
    fluxbox \
    firefox \
    apt-utils \
    python3 \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose the port for XPRA's web server (HTML5 access)
EXPOSE 14500

# Start Xvfb, fluxbox, and XPRA when the container starts
CMD Xvfb :1 -screen 0 1024x768x16 & \
    DISPLAY=:1 fluxbox & \
    xpra start :1 --bind-tcp=0.0.0.0:14500 --html=on --start-child=fluxbox --start=firefox && tail -f /dev/null
