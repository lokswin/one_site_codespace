# checks/service_specific.py
import subprocess
import logging
import os  # Ensure 'os' is imported here
import re  # Ensure 're' is imported here

VAR_PATTERN = re.compile(r'\$\{([^}:\s]+)(:-([^}]+))?\}')

def evaluate_env_var(var_string):
    """Evaluate environment variable with default value."""
    match = VAR_PATTERN.match(var_string)
    if match:
        var_name = match.group(1)
        default_value = match.group(3) or ''
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
                environment = config.get('environment', [])
                env_dict = {}
                for env_var in environment:
                    if isinstance(env_var, dict):
                        env_dict.update(env_var)
                    elif isinstance(env_var, str):
                        key, _, value = env_var.partition('=')
                        env_dict[key] = value

                db_user = evaluate_env_var(env_dict.get('POSTGRESQL_USER', '${POSTGRESQL_USER:-P0G_Us3}'))
                db_host = evaluate_env_var(env_dict.get('POSTGRESQL_HOSTNAME', '${POSTGRESQL_HOSTNAME:-localhost}'))
                db_port = evaluate_env_var(env_dict.get('POSTGRES_PORT', '${POSTGRES_PORT:-5432}'))
                db_password = evaluate_env_var(env_dict.get('POSTGRESQL_PASSWORD', '${POSTGRESQL_PASSWORD:-}'))
                db_name = evaluate_env_var(env_dict.get('POSTGRESQL_DATABASE', '${POSTGRESQL_DATABASE:-guacamole_db}'))

                env = os.environ.copy()
                if db_password:
                    env['PGPASSWORD'] = db_password

                # Get the container name, evaluating any environment variables
                container_name = config.get('container_name', service)
                container_name = evaluate_env_var(container_name)


                response = subprocess.run(
                    [
                        "docker", "exec", container_name,
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
