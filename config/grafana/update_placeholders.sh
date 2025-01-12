#!/bin/bash

# config/grafana/update_placeholders.sh

# Paths inside the container
DASHBOARD_DIR="/etc/grafana/provisioning/dashboards"
DATASOURCE_FILE="/etc/grafana/provisioning/datasources/datasources.yml"

echo "upd_phd: Starting the placeholder replacement process."


# Initialize associative array for UID mapping
declare -A DATASOURCE_UIDS

# Parse datasources.yaml to extract names and UIDs
CURRENT_NAME=""
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*-?[[:space:]]*name:[[:space:]]*\"?([a-zA-Z0-9_]+)\"? ]]; then
    CURRENT_NAME="${BASH_REMATCH[1]}"
    echo "upd_phd: Found datasource name: $CURRENT_NAME"
  elif [[ "$line" =~ ^[[:space:]]*uid:[[:space:]]*([a-zA-Z0-9_]+) ]]; then
    UID="${BASH_REMATCH[1]}"
    if [[ -n "$CURRENT_NAME" ]]; then
      DATASOURCE_UIDS["$CURRENT_NAME"]="$UID"
      echo "upd_phd: Found UID for $CURRENT_NAME: $UID"
      CURRENT_NAME=""
    fi
  fi
done < "$DATASOURCE_FILE"

# Debug: Display extracted datasources and UIDs
echo "upd_phd: Extracted datasources and UIDs:"
for NAME in "${!DATASOURCE_UIDS[@]}"; do
  echo "upd_phd: $NAME -> ${DATASOURCE_UIDS[$NAME]}"
done

# Replace placeholders in all dashboard JSON files
for DASHBOARD in "$DASHBOARD_DIR"/*.json; do
  echo "upd_phd: Processing dashboard file: $DASHBOARD"
  for NAME in "${!DATASOURCE_UIDS[@]}"; do
    PLACEHOLDER="DS_${NAME}"
    UID="${DATASOURCE_UIDS[$NAME]}"
    echo "upd_phd: Replacing placeholder $PLACEHOLDER with UID $UID in $DASHBOARD"
    sed -i "s|\"${PLACEHOLDER}\"|\"${UID}\"|g" "$DASHBOARD"
  done
done

# Debug: Log completion
echo "upd_phd: Placeholder replacement completed successfully."