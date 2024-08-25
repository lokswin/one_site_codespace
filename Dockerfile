# file: .devcontainer/Dockerfile
# This file defines the Docker image used by the devcontainer.
# It specifies the base image, dependencies, and setup required for the environment.

# Stage 1: Build noVNC and websockify
FROM debian:bookworm-slim as novnc-builder

RUN apt-get update && apt-get install -y git python3 python3-pip && \
    git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    cd /opt/noVNC && \
    pip3 install -r utils/websockify/requirements.txt

# Stage 2: Final Image
FROM debian:bookworm-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    qutebrowser \
    x11vnc \
    xvfb \
    fluxbox \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy noVNC from the build stage
COPY --from=novnc-builder /opt/noVNC /opt/noVNC

# Copy configuration files
COPY config/fluxbox-init /root/.fluxbox/init
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/cleanup.sh /usr/local/bin/cleanup.sh

# Set correct permissions
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/cleanup.sh

# Expose necessary ports
EXPOSE 5900 6080

# Set the non-root user and working directory
RUN useradd -m -s /bin/bash devuser
USER devuser
WORKDIR /home/devuser

# Start the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
