# main.py
import logging
import os
import yaml

from colorlog import ColoredFormatter
from config import check_required_env_variables
from checks.env_validation import validate_env_variables
from checks.network_validation import validate_network_connectivity
from checks.port_validation import check_ports
from checks.log_validation import check_logs
from checks.resource_validation import check_resources
from checks.healthcheck_validation import validate_healthchecks
from checks.service_specific import check_service_specifics

def main():
    # Set up logging with color support
    LOG_LEVEL = logging.INFO
    LOGFORMAT = "%(log_color)s%(asctime)s %(levelname)s: %(message)s"
    LOG_COLORS = {
        'DEBUG':    'white',
        'INFO':     'green',
        'WARNING':  'yellow',
        'ERROR':    'red',
        'CRITICAL': 'bold_red',
    }

    formatter = ColoredFormatter(LOGFORMAT, log_colors=LOG_COLORS)
    # Configure logging handlers
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    console_handler.setLevel(LOG_LEVEL)

    file_handler = logging.FileHandler("docker_checker.log")
    file_handler.setFormatter(logging.Formatter("%(asctime)s %(levelname)s: %(message)s"))
    file_handler.setLevel(LOG_LEVEL)

    logging.basicConfig(
        level=LOG_LEVEL,
        format='%(asctime)s %(levelname)s: %(message)s',
        handlers=[console_handler, file_handler]
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
