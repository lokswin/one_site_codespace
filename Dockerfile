# Use an Ubuntu base image
FROM python

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

RUN apt-get install -y websockify 

# Set environment variables
ENV DISPLAY=:1

RUN mkdir -p /root/.config/qutebrowser
# Add files
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./scripts/entrypoint.sh /opt/entrypoint.sh
COPY ./scripts/create_xauthority.sh /opt/create_xauthority.sh
COPY ./scripts/vnc_launch.sh /opt/vnc_launch.sh

# Make scripts executable
RUN chmod +x /opt/entrypoint.sh /opt/create_xauthority.sh /opt/vnc_launch.sh

# Expose the VNC and noVNC ports
EXPOSE 5901 6080

ARG CACHEBUST=1
COPY ./config/config.py /opt/config.py

# Set the entrypoint
ENTRYPOINT ["/opt/entrypoint.sh"]
