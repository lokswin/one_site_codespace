# OnePage Browser Container with OTP-Enabled Access

This project provides a containerized environment with secure OTP-based access to a browser interface using Guacamole and VNC, configured with Docker-Compose. It allows users to connect to a container, authenticate using a one-time password (OTP), and access Firefox automatically through the interface.

## Project Overview

The setup leverages open-source tools to provide a secure, accessible, and configurable development environment:
- **Docker** for containerization.
- **Guacamole** for remote access to the browser via VNC.
- **PSQL** for Guacamole authentification.
- **Xvfb** (X virtual framebuffer) to enable graphical applications within the container.
- **x11vnc** as the VNC server.
- **Firefox** as the default browser.

## File Overview

### `Dockerfile`
Defines the base environment for the container, installing and configuring dependencies necessary for VNC, Guacamole, and Firefox.

### `devcontainer.json`
Configures development container settings:
- Specifies the Dockerfile path and context.
- Forwards necessary ports:
  - **5901**: VNC server.
  - **6080**: Guacamole web interface.
  - **8080**: Tomcat server for web access.
  
Port visibility is configured with labels to distinguish between VNC and web interfaces.

### `one_site_start.sh`
A startup script to initialize the environment and services. It includes:
- Verification of the display port’s availability.
- Start-up of **Xvfb** on a specified display port for GUI applications.
- Launch of **x11vnc** to allow remote desktop connections.
- Start-up of **Firefox** in a virtual display session with **Fluxbox**.
- Initiation of the Guacamole daemon (`guacd`) and Tomcat server.

### `guacamole.properties`
Configures the Guacamole server settings, defining connection properties to interact with the VNC server.

### `user-mapping.xml`
Sets up user authentication for Guacamole:
- Defines username and password credentials.
- Includes a TOTP (Time-Based One-Time Password) secret key for OTP authentication.
- Specifies connection details to the **VNC Server** on `localhost:5901`.

## Setup Instructions

### 1. Build and Start the Container

Ensure Docker is installed and then use the following command to build and run the container:

```bash
docker build -t onepage-browser .
docker run -d -p 5901:5901 -p 6080:6080 -p 8080:8080 --name onepage-container onepage-browser


guacamole/guacd:1.5.5
guacamole/guacamole:1.5.5
postgres:17
bitnami/node-exporter:1.8.2
telegraf:1.32.3
prom/prometheus:latest
grafana/grafana:latest