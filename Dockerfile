# Dockerfile for Guacamole client
FROM guacamole/guacamole:latest

# Set environment variables as needed
ENV GUACAMOLE_HOME=/etc/guacamole
ENV GUACD_HOSTNAME=guacd
ENV GUACD_PORT=4822

# Copy configuration files into the Guacamole home directory
COPY config/guacamole.properties $GUACAMOLE_HOME/
COPY config/user-mapping.xml $GUACAMOLE_HOME/

# Run the default command
CMD ["catalina.sh", "run"]
