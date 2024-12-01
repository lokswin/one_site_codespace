# main.py
import logging
import os
import yaml

from config import check_required_env_variables
from checks.env_validation import validate_env_variables
from checks.network_validation import validate_network_connectivity
from checks.port_validation import check_ports
from checks.log_validation import check_logs
from checks.resource_validation import check_resources
from checks.healthcheck_validation import validate_healthchecks
from checks.service_specific import check_service_specifics

def main():
    # Set up logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)s: %(message)s',
        handlers=[
            logging.FileHandler("docker_checker.log"),
            logging.StreamHandler()
        ]
    )

    logging.info("=== Starting Automated Checks ===")

    # Load the Docker Compose configuration
    compose_file = os.getenv('COMPOSE_FILE', 'docker-compose.yml')
    try:
        with open(compose_file, 'r') as file:
            compose_config = yaml.safe_load(file)
            logging.info(f"Loaded Docker Compose configuration from {compose_file}")
    except Exception as e:
        logging.error(f"Failed to load {compose_file}: {e}")
        return

    # Check required environment variables
    check_required_env_variables(compose_config)

    # Execute checks
    validate_env_variables(compose_config)
    validate_network_connectivity(compose_config)
    check_ports(compose_config)
    check_logs(compose_config)
    check_resources(compose_config)
    validate_healthchecks(compose_config)
    check_service_specifics(compose_config)

    logging.info("=== Automated Checks Completed ===")

if __name__ == '__main__':
    main()
