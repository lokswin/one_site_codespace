#!/bin/sh

# Load environment variables from secrets or set defaults
export GUAC_USER=${GUAC_USER}
export GUAC_PASS=${GUAC_PASS}
export TOTP_SECRET_KEY=${TOTP_SECRET_KEY}
export VNC_HOSTNAME=${VNC_HOSTNAME:-localhost}
export VNC_PORT=${VNC_PORT:-5901}
export GUACD_HOSTNAME=${GUACD_HOSTNAME:-localhost}
export GUACD_PORT=${GUACD_PORT:-4822}
export DISPLAY=${DISPLAY:-:0}
export DEBUG_ALL=${DEBUG_ALL:-false}

# Debug log function
debug_log() {
    [ "$DEBUG_ALL" = "true" ] && echo "[DEBUG] $1"
}

# Log startup
debug_log "Starting Guacamole service with DISPLAY set to $DISPLAY"

# Create inline user-mapping.xml configuration
cat <<EOF > /usr/local/tomcat/.guacamole/user-mapping.xml
<user-mapping>
    <authorize username="${GUAC_USER}" password="${GUAC_PASS}">
        <param name="totp-secret-key" value="${TOTP_SECRET_KEY}" />
        <connection name="VNC Server">
            <protocol>vnc</protocol>
            <param name="hostname">${VNC_HOSTNAME}</param>
            <param name="port">${VNC_PORT}</param>
        </connection>
    </authorize>
</user-mapping>
EOF

# Start Guacamole (Tomcat server) with debug mode if enabled
if [ "$DEBUG_ALL" = "true" ]; then
    /usr/local/tomcat/bin/catalina.sh run -verbose:class -debug
else
    /usr/local/tomcat/bin/catalina.sh run
fi

# Keep the container running
exec "$@"
