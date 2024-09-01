# file: .devcontainer/Dockerfile
# This file defines the Docker image used by the devcontainer.
# It specifies the base image, dependencies, and setup required for the environment.

# Stage 1: Build noVNC and websockify
FROM debian:bookworm-slim as novnc-builder

# Set build arguments for cache usage
ARG BUILDKIT_INLINE_CACHE=1
ARG VNC_PASSWORD

RUN echo "Install Dependencies" && \
    apt-get update && apt-get install -y --no-install-recommends \
    git python3 python3-venv \
    x11vnc xvfb procps \
    xauth net-tools \
    qutebrowser \
    ca-certificates && \
    apt-get update && apt-get install -y --no-install-recommends && \
    apt-get clean \
    rm -rf /var/lib/apt/lists/*

RUN echo "Cloning noVNC repository" && \
    git clone --depth 1 https://github.com/novnc/noVNC.git /opt/noVNC

RUN echo "Cloning websockify repository" && \
    git clone --depth 1 https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Set up a virtual environment and install Python dependencies
RUN python3 -m venv /opt/noVNC/venv && \
    /opt/noVNC/venv/bin/pip install --upgrade pip && \
    /opt/noVNC/venv/bin/pip install numpy && \
    /opt/noVNC/venv/bin/pip install -r /opt/noVNC/utils/websockify/test-requirements.txt

# Create VNC password file securely
RUN mkdir -p /opt/noVNC && \
    echo "$VNC_PASSWORD" | x11vnc -storepasswd - /opt/noVNC/passwd

# Activate virtual environment for further steps
ENV PATH="/opt/noVNC/venv/bin:$PATH"
ENV DISPLAY=:0
ENV USER=user

# Expose necessary ports for noVNC
EXPOSE 6080

# Setup a basic VNC server entrypoint
# Copy entrypoint script and set permissions
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./scripts/startVNCClient.sh /usr/local/bin/startVNCClient.sh
COPY ./scripts/cleanup.sh /usr/local/bin/cleanup.sh
COPY ./scripts/x11vnc.sh /usr/local/bin/x11vnc.sh

RUN chmod +x /usr/local/bin/entrypoint.sh \
             /usr/local/bin/startVNCClient.sh \
             /usr/local/bin/cleanup.sh \
             /usr/local/bin/x11vnc.sh


# Use the external script as the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
