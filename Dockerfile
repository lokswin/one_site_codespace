# file: .devcontainer/Dockerfile
# This file defines the Docker image used by the devcontainer.
# It specifies the base image, dependencies, and setup required for the environment.

# Stage 1: Build noVNC and websockify
FROM debian:bookworm-slim as novnc-builder

# Set build arguments for cache usage
ARG BUILDKIT_INLINE_CACHE=1
ARG VNC_PASSWORD

RUN echo "Install Dependencies" && \
    apt-get update && apt-get install -y git python3 python3-pip python3-venv \
    x11vnc xvfb procps \
    libssl-dev libffi-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Cloning noVNC repository" && \
    git clone https://github.com/novnc/noVNC.git /opt/noVNC

RUN echo "Cloning websockify repository" && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Set up a virtual environment and install Python dependencies
RUN python3 -m venv /opt/noVNC/venv && \
    /opt/noVNC/venv/bin/pip install --upgrade pip && \
    /opt/noVNC/venv/bin/pip install -r /opt/noVNC/utils/websockify/test-requirements.txt

# Create VNC password file securely
RUN mkdir -p /opt/noVNC && \
    echo $VNC_PASSWORD > /tmp/vnc_pass && \
    x11vnc -storepasswd $(cat /tmp/vnc_pass) /opt/noVNC/passwd && \
    rm -f /tmp/vnc_pass

# Activate virtual environment for further steps
ENV PATH="/opt/noVNC/venv/bin:$PATH"
ENV DISPLAY=:0

# Expose necessary ports for noVNC
EXPOSE 6080

# Setup a basic VNC server entrypoint (if required)
# Define the entrypoint script
ENTRYPOINT ["sh", "-c", "\
    Xvfb :0 -screen 0 1024x768x16 & \
    x11vnc -rfbauth /opt/noVNC/passwd -display :0 -forever -loop -rfbport 5900 -shared & \
    /opt/noVNC/venv/bin/qutebrowser & \
    /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080"]



# # Copy noVNC from the build stage
# COPY --from=novnc-builder /opt/noVNC /opt/noVNC

# # Copy configuration files
# COPY config/fluxbox-init /root/.fluxbox/init
# COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
# COPY scripts/cleanup.sh /usr/local/bin/cleanup.sh

# # Set correct permissions
# RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/cleanup.sh

# # Expose necessary ports
# EXPOSE 5900 6080

# # Set the non-root user and working directory
# RUN useradd -m -s /bin/bash devuser
# USER devuser
# WORKDIR /home/devuser

# # Start the entrypoint script
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
