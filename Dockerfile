# file: .devcontainer/Dockerfile
# This file defines the Docker image used by the devcontainer.
# It specifies the base image, dependencies, and setup required for the environment.

# Stage 1: Build noVNC and websockify
FROM debian:bookworm-slim as novnc-builder

RUN apt-get update && apt-get install -y git python3 python3-pip

RUN echo "Cloning noVNC repository" && \
    git clone https://github.com/novnc/noVNC.git /opt/noVNC

RUN echo "Cloning websockify repository" && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

RUN echo "Installing Python dependencies for websockify" && \
    cd /opt/noVNC && pip3 install -r utils/websockify/requirements.txt

# Setup a basic VNC server entrypoint (if required)
ENTRYPOINT ["x11vnc", "-forever", "-usepw", "-create", "-display", ":0"]

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
