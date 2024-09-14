# Use the official Python slim image for a smaller base
FROM python:3.9-slim

# Install necessary packages for VNC and minimal browser control
RUN apt-get update && apt-get install -y --no-install-recommends \
    x11vnc \
    xvfb \
    fluxbox \
    websockify \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install pip packages if needed (for example, Flask for remote control)
# RUN pip install <your_required_python_packages>

# Set up a minimal configuration for VNC and display
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd "your_vnc_password" ~/.vnc/passwd

# Expose the necessary ports for VNC and web interface (optional for NoVNC)
EXPOSE 5901 6080

# Start VNC server and minimal window manager (fluxbox)
CMD ["sh", "-c", "Xvfb :1 -screen 0 1024x768x16 & fluxbox & x11vnc -forever -usepw -display :1"]
