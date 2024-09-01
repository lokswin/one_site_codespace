# Website Browser Container with VNC Access

This repository provides a containerized environment for accessing a website (free version) using GitHub Codespaces. The setup is optimized to be lightweight, secure, and easy to use, with additional support for VNC access to manage the browser remotely.

## Features

- **Lightweight**: Utilizes `qutebrowser`, a minimal web browser, for accessing the website.
- **VNC Support**: Includes an integrated VNC server (`x11vnc`) for remote access to the browser via `noVNC`.
- **Secure**: Runs as a non-root user with restricted network access and a read-only filesystem.
- **Open-Source**: Relies exclusively on free and open-source tools.
- **Simplified**: Streamlined setup with minimal complexity and dependencies.

## Setup Instructions

1. **Fork and Clone the Repository**:
   Fork this repository to your GitHub account and clone it to your local machine.

2. **Open in GitHub Codespaces**:
   Open the repository in GitHub Codespaces to start the environment automatically.

3. **Run the Container**:
   The environment will start and launch `qutebrowser` in fullscreen mode, pointing to the website. The VNC server will also start, allowing remote access if needed.

## Configuration

- **Dockerfile**: Defines the container image and its dependencies, including the VNC server and web browser.
- **`entrypoint.sh`**: Launches the necessary services, including `x11vnc` and `qutebrowser`.
- **`x11vnc.sh`**: Custom script to start the VNC server with the correct display and user settings.
- **`startVNCClient.sh`**: Script to provide a noVNC link for browser-based VNC access.
- **`cleanup.sh`**: Cleans up temporary files and reduces image size after setup.

## Security

- **Non-Root Execution**: The container runs as a non-root user to enhance security.
- **Network Restrictions**: The container is restricted to accessing only the specified website.
- **Read-Only Filesystem**: The filesystem is mounted as read-only to prevent unauthorized modifications.
- **VNC Password Protection**: The VNC server is secured with a password stored securely within the container.

## VNC Access

For remote access to the browser:
- Access the VNC server via a web browser using the provided noVNC link.
- Ensure the VNC server password is securely stored and configured.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributions

Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure that all code adheres to the project's guidelines and passes the CI checks.

## Contact

For any questions or issues, please open an issue on the [GitHub repository](https://github.com/).

---

Feel free to modify the contact link to match your GitHub repository URL.

## Testing and Validation

- **Functional Testing**: Ensure that the setup works correctly in GitHub Codespaces and the VNC server starts as expected.
- **Performance Monitoring**: Monitor the container’s performance to ensure it remains efficient, especially when using VNC.

## Cleanup

A `cleanup.sh` script is included to remove unnecessary files and reduce the overall image size. This script will be executed automatically as part of the container’s entrypoint to ensure a minimal footprint.
