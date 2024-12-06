# network_validation.py

import subprocess
import logging
import os  # Ensure 'os' is imported
import re  # Ensure 're' is imported

VAR_PATTERN = re.compile(r'\$\{([^}:\s]+)(:-([^}]+))?\}')

def evaluate_env_var(var_string):
    """Evaluate environment variable with default value."""
    match = VAR_PATTERN.match(str(var_string))
    if match:
        var_name = match.group(1)
        default_value = match.group(3) or ''
        return os.getenv(var_name, default_value)
    return var_string

def validate_network_connectivity(compose_config):
    """Validate network connectivity between services."""
    logging.info("Validating network connectivity between services...")
    services = compose_config.get('services', {})

    for service_name, config in services.items():
        depends_on = config.get('depends_on', [])

        # Get and evaluate the container name for the service
        service_container_name = config.get('container_name', service_name)
        service_container_name = evaluate_env_var(service_container_name)

        for dependency_name in depends_on:
            # Get and evaluate the container name for the dependency
            dependency_config = services.get(dependency_name, {})
            dependency_container_name = dependency_config.get('container_name', dependency_name)
            dependency_container_name = evaluate_env_var(dependency_container_name)

            try:
                logging.info(f"Checking connectivity from '{service_name}' to '{dependency_name}'...")

                # Use the evaluated container names in 'docker exec'
                response = subprocess.run(
                    ["docker", "exec", service_container_name, "ping", "-c", "3", dependency_name],
                    capture_output=True, text=True
                )
                if response.returncode == 0:
                    logging.info(f"[OK] '{service_name}' can reach '{dependency_name}'.")
                else:
                    logging.warning(f"[FAIL] '{service_name}' cannot reach '{dependency_name}': {response.stderr.strip()}")
            except Exception as e:
                logging.error(f"[ERROR] Connectivity check failed for '{service_name}': {e}")

    # Validate network configurations
    logging.info("Validating network configurations...")
    networks = compose_config.get('networks', {})
    for net_name, net_config in networks.items():
        logging.info(f"Network '{net_name}' with driver '{net_config.get('driver', 'default')}'")

    # Check if services are connected to the correct networks
    for service, config in services.items():
        service_networks = config.get('networks', [])
        if not service_networks:
            logging.warning(f"[FAIL] Service '{service}' is not connected to any network.")
        else:
            logging.info(f"[OK] Service '{service}' is connected to networks: {', '.join(service_networks)}")

    try:
        logging.info(f"Checking connectivity from '{service_name}' to '{dependency_name}'...")
        response = subprocess.run(
            ["docker", "exec", service_container_name, "ping", "-c", "3", dependency_name],
            capture_output=True, text=True
        )
        if response.returncode == 0:
            logging.info(f"[OK] '{service_name}' can reach '{dependency_name}'.")
        else:
            logging.warning(f"[FAIL] '{service_name}' cannot reach '{dependency_name}': {response.stderr.strip()}")
            logging.warning(f"Stdout: {response.stdout.strip()}")  # Add this line for more details
    except Exception as e:
        logging.error(f"[ERROR] Connectivity check failed for '{service_name}': {str(e)}")

