# Use the official Guacamole image as the base
FROM guacamole/guacamole:latest

# Set build arguments to pass environment variables at build time
ARG GUAC_USER
ARG GUAC_PASS
ARG TOTP_SECRET_KEY
ARG VNC_HOSTNAME
ARG VNC_PORT
ARG GUACD_HOSTNAME
ARG GUACD_PORT

# Switch to root to install packages
USER root

# Install envsubst for environment variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Switch back to the default user
USER guacamole

# Create /etc/guacamole directory if it does not exist
RUN mkdir -p /etc/guacamole

# Copy the user-mapping.xml and guacamole.properties templates
COPY ./config/user-mapping_template.xml /tmp/user-mapping.xml.template
COPY ./config/guacamole_template.properties /tmp/guacamole.properties.template

# Substitute environment variables in the templates and move to /etc/guacamole
RUN envsubst < /tmp/user-mapping.xml.template > /etc/guacamole/user-mapping.xml && \
    envsubst < /tmp/guacamole.properties.template > /etc/guacamole/guacamole.properties && \
    rm /tmp/user-mapping.xml.template /tmp/guacamole.properties.template

#

# Copy the entrypoint script and make it executable
COPY ./scripts/one_site_start.sh /usr/local/bin/one_site_start.sh
RUN chmod +x /usr/local/bin/one_site_start.sh

# Use the custom entrypoint script
ENTRYPOINT ["/usr/local/bin/one_site_start.sh"]

# Expose the Guacamole web interface port
EXPOSE 8080
