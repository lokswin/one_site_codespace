#!/bin/sh
# config/prometheus-entrypoint.sh - Configures and runs Prometheus

# Debug mode: Print each command as it is executed (optional, remove if not needed)
set -x

# Define paths for the template and actual config files
TEMPLATE_FILE="/opt/bitnami/prometheus/prometheus.yml.template"
CONFIG_FILE="/opt/bitnami/prometheus/prometheus.yml"

# Debug: Print the provided environment variables
echo "DEBUG: Environment Variables:"
env | grep -E 'PROMET_|NODE_EX_|TELEG_|GUACD_|POSTGRES|GRAFANA'

# Ensure the template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: Template file $TEMPLATE_FILE not found!"
  exit 1
fi

# Debug: Show contents of the template file
echo "DEBUG: Template file contents:"
cat "$TEMPLATE_FILE"

# Copy the template file to the actual configuration file
cp "$TEMPLATE_FILE" "$CONFIG_FILE"

# Debug: Show contents of the copied file before substitution
echo "DEBUG: Config file before substitution:"
cat "$CONFIG_FILE"

# Replace placeholders in the configuration file
# Replace placeholders in the configuration file
# Replace placeholders in the configuration file using a portable method
env | while IFS='=' read -r key value; do
  # Escape special characters in the value for safe replacement
  escaped_value=$(printf '%s' "$value" | sed 's|[&/]|\\&|g')
  # Replace placeholders in the config file
  sed -i "s|\${$key}|$escaped_value|g" "$CONFIG_FILE"
done

# Debug: Show contents of the config file after substitution
echo "DEBUG: Config file after substitution:"
cat "$CONFIG_FILE"

# Run Prometheus with the specified options
exec prometheus \
  --config.file="$CONFIG_FILE" \
  --web.listen-address=:${PROMET_PORT:-7342} \
  --storage.tsdb.retention.time=10d \
  --storage.tsdb.retention.size=3GB
