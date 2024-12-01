# checks/service_specific.py
import subprocess
import logging
import os
import re

VAR_PATTERN = re.compile(r'\$\{([^}:\s]+)(:-([^}]+))?\}')

def evaluate_env_var(var_string):
    """Evaluate environment variable with default value."""
    match = VAR_PATTERN.match(var_string)
    if match:
        var_name = match.group(1)
        default_value = match.group(3)
        return os.getenv(var_name, default_value)
    return var_string

def check_service_specifics(compose_config):
    """Run additional checks specific to certain services."""
    logging.info("Running service-specific checks...")
    services = compose_config.get('services', {})
    for service, config in services.items():
        if service == "psql_server":
            logging.info(f"Checking database connection for service '{service}'...")
            try:
                # Fetch database configuration with default values
                db_user = evaluate_env_var(config['environment'][0].split('=')[1])
                db_host = evaluate_env_var(config['container_name'])
                db_port = evaluate_env_var('${POSTGRES_PORT:-5432}')
                db_password = evaluate_env_var('${POSTGRES_PASSWORD:-}')
                db_name = evaluate_env_var('${POSTGRESQL_DATABASE:-guacamole_db}')

                env = os.environ.copy()
                if db_password:
                    env['PGPASSWORD'] = db_password

                response = subprocess.run(
                    [
                        "pg_isready",
                        "-U", db_user,
                        "-h", db_host,
                        "-p", db_port,
                        "-d", db_name
                    ],
                    capture_output=True, text=True, env=env
                )
                if response.returncode == 0:
                    logging.info(f"[OK] Database '{service}' is reachable.")
                else:
                    logging.warning(f"[FAIL] Database '{service}' is not reachable: {response.stderr.strip()}")
            except Exception as e:
                logging.error(f"[ERROR] Database check failed for service '{service}': {e}")
