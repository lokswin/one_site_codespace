
#!/bin/bash

# ./scripts/entrypoint.sh
# This script is executed when the Docker container starts.
# It sets up the environment, starts necessary services, and launches qutebrowser.

# Exit on error
set -e

# Start Xvfb (X Virtual Frame Buffer)
Xvfb :0 -screen 0 1024x768x16 &

# Start a simple window manager (Fluxbox)
fluxbox &

# Start the VNC server
x11vnc -display :0 -forever -shared -rfbport 5900 &

# Start noVNC (VNC client in a browser)
supervisord -c /opt/noVNC/utils/novnc.conf &

# Launch qutebrowser in fullscreen mode with ChatGPT
qutebrowser --target=window --temp --qt-arg fullscreen https://chat.openai.com/

# Run cleanup script to remove unnecessary components
/usr/local/bin/cleanup.sh

# Wait and keep the container running
wait -n

# If any of the above processes exit, the container will stop
exit $?
