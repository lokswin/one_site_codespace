# checks/env_validation.py
import os
import logging
import re

VAR_PATTERN = re.compile(r'\$\{([^}:\s]+)(:-([^}]+))?\}')

def validate_env_variables(compose_config):
    """Validate the presence of required environment variables."""
    logging.info("Validating environment variables in services...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        logging.info(f"Validating environment variables for service '{service}'...")
        env_vars = set()
        # Extract variables from 'environment' section
        env_section = config.get('environment', [])
        for var in env_section:
            if isinstance(var, dict):
                env_vars.update(var.keys())
            elif isinstance(var, str):
                key = var.split('=')[0]
                env_vars.add(key)

        # Extract variables from the entire service configuration
        serialized_config = str(config)
        matches = VAR_PATTERN.findall(serialized_config)
        for match in matches:
            env_vars.add(match[0])

        missing_vars = []
        for var in env_vars:
            if not os.getenv(var):
                missing_vars.append(var)

        if missing_vars:
            logging.warning(f"[FAIL] Service '{service}' is missing environment variables: {', '.join(missing_vars)}")
        else:
            logging.info(f"[OK] All environment variables are set for service '{service}'.")
