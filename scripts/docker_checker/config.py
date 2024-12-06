# config.py
import os
import logging
import re

# Regular expression to extract variable names and default values from Docker Compose syntax
VAR_PATTERN = re.compile(r'\$\{([^}:\s]+)(:-([^}]+))?\}')

# Function to extract environment variables from the Docker Compose file
def extract_env_variables(compose_config):
    env_vars = set()
    services = compose_config.get('services', {})
    for service, config in services.items():
        # Environment variables in 'environment' section
        env_section = config.get('environment', [])
        for var in env_section:
            if isinstance(var, dict):
                env_vars.update(var.keys())
            elif isinstance(var, str):
                key = var.split('=')[0]
                env_vars.add(key)

        # Environment variables in other sections (e.g., 'container_name', 'ports', 'volumes')
        serialized_config = str(config)
        matches = VAR_PATTERN.findall(serialized_config)
        for match in matches:
            env_vars.add(match[0])

    return env_vars

def check_required_env_variables(compose_config):
    """Check if required environment variables are set."""
    logging.info("Checking required environment variables...")

    env_vars = extract_env_variables(compose_config)
    missing_vars = []
    for var in env_vars:
        value = os.getenv(var)
        if value is None:
            logging.warning(f"Environment variable '{var}' is not set.")
            missing_vars.append(var)
        else:
            logging.info(f"Environment variable '{var}' is set to '{value}'")

    if missing_vars:
        logging.warning(f"The following environment variables are not set: {', '.join(missing_vars)}")
    else:
        logging.info("All required environment variables are set.")

# Other configurations can be added here if needed
