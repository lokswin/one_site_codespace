#!/bin/bash
# file: ./scripts/create_xauthority.sh

# Create a dummy .Xauthority file
touch $XAUTH_FILE

# Add a dummy authentication entry (format: MIT-MAGIC-COOKIE-1 <cookie>)
echo "Adding dummy Xauthority entry..."
# Generate a cookie (32 hex chars) and add it to the file
echo "MIT-MAGIC-COOKIE-1 $(openssl rand -hex 16)" >> $XAUTH_FILE
