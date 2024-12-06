#!/bin/sh

# Load environment variables from secrets or set defaults
# export GUAC_USER=${GUAC_USER}
# export GUAC_PASS=${GUAC_PASS}
# export TOTP_SECRET_KEY=${TOTP_SECRET_KEY}
# export VNC_HOSTNAME=${VNC_HOSTNAME:-localhost}
# export VNC_PORT=${VNC_PORT:-5901}
# export GUACD_HOSTNAME=${GUACD_HOSTNAME:-localhost}
# export GUACD_PORT=${GUACD_PORT:-7651}
# export DISPLAY=${DISPLAY:-:0}
# export DEBUG_ALL=${DEBUG_ALL:-false}

# Debug log function
debug_log() {
    [ "$DEBUG_ALL" = "true" ] && echo "[DEBUG $(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Log the operation
debug_log "Changing ownership of /usr/local/tomcat/conf and /usr/local/tomcat/.guacamole to UID:$(id -u) GID:$(id -g)"

# if [ "$(id -u)" -ne 0 ]; then
#     debug_log "Running as non-root user. Skipping ownership change for /usr/local/tomcat/conf and /usr/local/tomcat/.guacamole."
# else
#     debug_log "Changing ownership of /usr/local/tomcat/conf and /usr/local/tomcat/.guacamole to UID:$(id -u) GID:$(id -g)"
#     if chown -R $(id -u):$(id -g) /usr/local/tomcat/conf /usr/local/tomcat/.guacamole 2>/tmp/chown_error.log; then
#         debug_log "Ownership successfully updated for directories."
#     else
#         debug_log "Failed to update ownership. See /tmp/chown_error.log for details."
#         exit 1
#     fi
# fi

debug_log "Checking directory permissions for /usr/local/tomcat/conf/Catalina/localhost"

# Ensure required directories exist and are writable
check_directory() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo "[INFO] Directory $dir does not exist. Creating..."
        mkdir -p "$dir"
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to create directory $dir. Exiting."
            exit 1
        fi
    fi

    if [ ! -w "$dir" ]; then
        echo "[ERROR] Directory $dir is not writable. Exiting."
        exit 1
    fi
}

# Check critical directories
# check_directory "/usr/local/tomcat/conf/Catalina/localhost"
# check_directory "/usr/local/tomcat/.guacamole"




# Log startup
debug_log "Starting Guacamole service with DISPLAY_GUACD set to $DISPLAY_GUACD"

# Create inline user-mapping.xml configuration
# cat <<EOF > /usr/local/tomcat/.guacamole/user-mapping.xml
# <user-mapping>
#     <authorize username="${GUAC_USER}" password="${GUAC_PASS}">
#         <param name="totp-secret-key" value="${TOTP_SECRET_KEY}" />
#         <connection name="VNC Server">
#             <protocol>vnc</protocol>
#             <param name="hostname">${VNC_HOSTNAME}</param>
#             <param name="port">${VNC_PORT}</param>
#         </connection>
#     </authorize>
# </user-mapping>
# EOF

# Start Guacamole (Tomcat server) with debug mode if enabled
# debug_log "Start Guacamole"
# if [ "$DEBUG_ALL" = "true" ]; then
#     export JAVA_OPTS="-verbose:class -Xdebug"
#     /usr/local/tomcat/bin/catalina.sh run
# else
#     /usr/local/tomcat/bin/catalina.sh run
# fi

# Keep the container running
if [ "$#" -eq 0 ]; then
    exec tail -f /dev/null
else
    exec "$@"
fi
