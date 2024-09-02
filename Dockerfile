# file: .devcontainer/Dockerfile
# This file defines the Docker image used by the devcontainer.
# It specifies the base image, dependencies, and setup required for the environment.

# Stage 1: Build noVNC and websockify
FROM debian:bookworm-slim as novnc-builder

# Set build arguments for cache usage
ARG BUILDKIT_INLINE_CACHE=1
ARG VNC_PASSWORD
ARG USERNAME=myuser67867
ARG GROUPNAME=mygroup

RUN echo "Install Dependencies" && \
    apt-get update && apt-get install -y --no-install-recommends \
    git python3 python3-venv \
    x11vnc xvfb procps \ 
    xauth net-tools \
    qutebrowser \
    ca-certificates openssl && \
    apt-get clean &&\
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

ENV VNC_AUTH_FILE=/opt/noVNC/passwd
# Create VNC password file securely and create non-root user
RUN groupadd -r $GROUPNAME && \
    useradd -r -g $GROUPNAME -m $USERNAME && \
    mkdir -p /opt/noVNC && \
    echo "$VNC_PASSWORD" | x11vnc -storepasswd - $VNC_AUTH_FILE && \
    chmod 600 $VNC_AUTH_FILE && \
    mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Activate virtual environment for further steps
ENV PATH="/opt/noVNC/venv/bin:$PATH"
ENV DISPLAY=:0
ENV LOG_ONE_PATH=/tmp/log/onepage-browser-container
ENV USERNAME=$USERNAME
ENV HOME=/home/$USERNAME
ENV XAUTH_FILE=/tmp/.Xauthority
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV PORT=6080

USER $USERNAME
WORKDIR $HOME



# Expose necessary ports for noVNC
EXPOSE 6080
EXPOSE 5900

# Setup a basic VNC server entrypoint
# Copy entrypoint script and set permissions
COPY --chown=$USERNAME:$GROUPNAME ./scripts/entrypoint.sh $HOME/entrypoint.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/startVNCClient.sh $HOME/startVNCClient.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/cleanup.sh $HOME/cleanup.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/create_xauthority.sh $HOME/create_xauthority.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/x11vnc.sh $HOME/x11vnc.sh
COPY --chown=$USERNAME:$GROUPNAME ./scripts/mtu.sh $HOME/mtu.sh
COPY --chown=$USERNAME:$GROUPNAME ./config/config.py $HOME/config.py

RUN chmod +x $HOME/entrypoint.sh \
             $HOME/startVNCClient.sh \
             $HOME/cleanup.sh \
             $HOME/create_xauthority.sh \
             $HOME/x11vnc.sh\
             $HOME/mtu.sh


# Use the external script as the entrypoint
ENTRYPOINT ["sh", "-c", "$HOME/entrypoint.sh"]