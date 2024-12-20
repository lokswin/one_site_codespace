# checks/healthcheck_validation.py
import logging

def validate_healthchecks(compose_config):
    """Validate health check configurations."""
    logging.info("Validating health check configurations...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        healthcheck = config.get('healthcheck')
        if healthcheck:
            test = healthcheck.get('test')
            interval = healthcheck.get('interval')
            timeout = healthcheck.get('timeout')
            retries = healthcheck.get('retries')
            if test and interval and timeout and retries is not None:
                logging.info(f"[OK] Service '{service}' health check is properly configured.")
            else:
                logging.warning(f"[FAIL] Service '{service}' health check is missing parameters.")
        else:
            logging.warning(f"[FAIL] Service '{service}' does not have a health check configured.")
