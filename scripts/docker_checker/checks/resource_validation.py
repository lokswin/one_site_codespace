# checks/resource_validation.py
import logging

def check_resources(compose_config):
    """Validate resource constraints for services."""
    logging.info("Validating resource constraints...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        mem_limit = config.get('mem_limit')
        cpu_shares = config.get('cpu_shares')
        cpuset = config.get('cpuset')
        if mem_limit and cpu_shares:
            logging.info(f"[OK] Service '{service}' resource limits are set (mem_limit={mem_limit}, cpu_shares={cpu_shares}, cpuset={cpuset}).")
        else:
            logging.warning(f"[FAIL] Service '{service}' resource limits are not properly configured.")
