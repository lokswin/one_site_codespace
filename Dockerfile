# Use an official lightweight base image
FROM alpine:3.20

# Enable debugging with an ARG
ARG DEBUG=true

# Update and install necessary packages
RUN apk update && apk add --no-cache \
    firefox \
    xvfb \
    x11vnc \
    fluxbox \
    xauth \
    xdpyinfo \
    bash \
    net-tools \
    lsof \
    tini \
    openjdk11 \
    tomcat9 \
    guacd \
    guacamole-server \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/*

# Set up Tomcat for Guacamole
RUN mkdir -p /etc/guacamole /var/lib/guacamole/extensions /var/lib/tomcat9/webapps && \
    wget -O /var/lib/tomcat9/webapps/guacamole.war https://downloads.apache.org/guacamole/1.5.0/binary/guacamole-1.5.0.war && \
    wget -O /etc/guacamole/extensions/guacamole-auth-totp.jar https://github.com/bithollow/guacamole-auth-totp/releases/download/1.4.0/guacamole-auth-totp-1.4.0.jar 
                                                                https://apache.org/dyn/closer.lua/guacamole/1.5.5/binary/guacamole-auth-totp-1.5.5.tar.gz
# Copy configuration files (guacamole.properties and user-mapping.xml)
COPY config/guacamole.properties user-mapping.xml /etc/guacamole/

RUN echo "${X11VNC_PASSWORD}" | x11vnc -storepasswd - /etc/x11vnc.pass

# Set appropriate permissions for sensitive files
RUN chown guacuser:guacgroup /etc/guacamole/guacamole.properties /etc/guacamole/user-mapping.xml && \
    chmod 600 /etc/guacamole/guacamole.properties /etc/guacamole/user-mapping.xml

# Create startup script for VNC and Xvfb
COPY ./scripts/one_site_start.sh /usr/local/bin/one_site_start.sh
RUN chmod +x /usr/local/bin/one_site_start.sh

# Add healthcheck for Tomcat and Guacamole services
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:8080/guacamole || exit 1

# Use tini as the entrypoint for proper PID 1 handling
ENTRYPOINT ["/sbin/tini", "--"]

RUN addgroup -S guacgroup && adduser -S guacuser -G guacgroup
USER guacuser

# Start the container with the custom script
CMD ["/usr/local/bin/one_site_start.sh"]
