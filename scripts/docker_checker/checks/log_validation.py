# checks/log_validation.py
import logging

def check_logs(compose_config):
    """Validate log rotation settings."""
    logging.info("Validating log rotation settings...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        logging_config = config.get('logging', {})
        driver = logging_config.get('driver', 'default')
        options = logging_config.get('options', {})
        max_size = options.get('max-size')
        max_file = options.get('max-file')
        if driver != 'default' and max_size and max_file:
            logging.info(f"[OK] Service '{service}' log rotation is configured (driver={driver}, max-size={max_size}, max-file={max_file}).")
        else:
            logging.warning(f"[FAIL] Service '{service}' log rotation is not properly configured.")
