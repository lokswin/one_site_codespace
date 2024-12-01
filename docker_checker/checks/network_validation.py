# checks/network_validation.py
import subprocess
import logging

def validate_network_connectivity(compose_config):
    """Validate network connectivity between services."""
    logging.info("Validating network connectivity between services...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        depends_on = config.get('depends_on', [])
        for dependency in depends_on:
            try:
                logging.info(f"Checking connectivity from '{service}' to '{dependency}'...")
                response = subprocess.run(
                    ["docker", "exec", service, "ping", "-c", "3", dependency],
                    capture_output=True, text=True
                )
                if response.returncode == 0:
                    logging.info(f"[OK] '{service}' can reach '{dependency}'.")
                else:
                    logging.warning(f"[FAIL] '{service}' cannot reach '{dependency}': {response.stderr.strip()}")
            except Exception as e:
                logging.error(f"[ERROR] Connectivity check failed for '{service}': {e}")

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
