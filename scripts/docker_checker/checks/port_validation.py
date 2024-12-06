# checks/port_validation.py
import subprocess
import logging
import re
import os  # Add this line to import the 'os' module

VAR_PATTERN = re.compile(r'\$\{([^}:\s]+)(:-([^}]+))?\}')

def evaluate_port(port_mapping):
    """Evaluate port mapping with environment variables."""
    # Replace environment variables in the port mapping string
    def replace_var(match):
        var_name = match.group(1)
        default_value = match.group(3)
        return os.getenv(var_name, default_value or '')
    port_mapping = re.sub(VAR_PATTERN, replace_var, port_mapping)
    return port_mapping

def check_ports(compose_config):
    """Check if services expose their ports correctly."""
    logging.info("Checking exposed ports...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        ports = config.get('ports', [])
        for port_mapping in ports:
            if isinstance(port_mapping, dict):
                host_port = str(port_mapping.get('published'))
            else:
                port_mapping = evaluate_port(port_mapping)
                host_port = port_mapping.split(':')[0]
            try:
                logging.info(f"Testing port {host_port} for service '{service}'...")
                response = subprocess.run(
                    ["nc", "-zv", "localhost", host_port],
                    capture_output=True,
                    text=True
                )
                if response.returncode == 0:
                    logging.info(f"[OK] Port {host_port} for service '{service}' is accessible.")
                else:
                    logging.warning(f"[FAIL] Port {host_port} for service '{service}' is not accessible: {response.stderr.strip()}")
            except Exception as e:
                logging.error(f"[ERROR] Port check failed for service '{service}': {e}")
