# file: .devcontainer/Dockerfile
# This file defines the Docker image used by the devcontainer.
# It specifies the base image, dependencies, and setup required for the environment.

# Base Image
FROM debian:bookworm-slim

# Set build arguments for cache usage
ARG VNC_PASSWORD
ARG USERNAME=myuser67867
ARG GROUPNAME=mygroup

# Install necessary dependencies
RUN echo "Step: Installing dependencies..." && \
    apt-get update && apt-get install -y --no-install-recommends \
    git python3 python3-pip python3-venv \
    x11vnc xvfb procps \
    xauth net-tools \
    qutebrowser \
    wget novnc \
    ca-certificates openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends python3-websockify
RUN apt-get install -y novnc
# Setup Python virtual environment (optional, based on your needs)
RUN echo "Step: Setting up Python virtual environment..." && \
    python3 -m venv /opt/noVNC/venv && \
    /opt/noVNC/venv/bin/pip install --upgrade pip && \
    /opt/noVNC/venv/bin/pip install numpy && \
    echo "Python virtual environment set up successfully."

# Create a non-root user and set up VNC password
RUN echo "Step 4: Creating VNC password file and non-root user..." && \
    groupadd -r $GROUPNAME && \
    useradd -r -g $GROUPNAME -m $USERNAME && \
    mkdir -p /opt/noVNC && \
    echo "$VNC_PASSWORD" > /opt/noVNC/vncpasswd && \
    x11vnc -storepasswd $(cat /opt/noVNC/vncpasswd) /opt/noVNC/passwd && \
    chmod 600 /opt/noVNC/passwd && \
    rm /opt/noVNC/vncpasswd && \
    mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && \
    echo "VNC password file and non-root user created successfully."

# Set environment variables
ENV PATH="/opt/noVNC/venv/bin:$PATH"
ENV DISPLAY=:0
ENV LOG_ONE_PATH=/tmp/log/onepage-browser-container
ENV USERNAME=$USERNAME
ENV HOME=/home/$USERNAME
ENV XAUTH_FILE=/tmp/.Xauthority
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV PORT=6080

# Switch to non-root user
USER $USERNAME
WORKDIR $HOME

# Expose necessary ports for noVNC
EXPOSE 6080 5900

# Copy scripts and set permissions
COPY --chown=$USERNAME:$GROUPNAME ./scripts/entrypoint.sh $HOME/entrypoint.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/create_xauthority.sh $HOME/create_xauthority.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/vnc_launch.sh $HOME/vnc_launch.sh
COPY --chown=$USERNAME:$GROUPNAME ./config/config.py $HOME/config.py

RUN chmod +x $HOME/entrypoint.sh \
             $HOME/create_xauthority.sh \
             $HOME/vnc_launch.sh

# Use the external script as the entrypoint
ENTRYPOINT ["sh", "-c", "$HOME/entrypoint.sh"]
