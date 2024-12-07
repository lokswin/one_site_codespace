-- /config/psql/schema/init/init-guacamole.sql
-- Create the database if it doesn't exist
SELECT 'CREATE DATABASE guacamole_db'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = 'guacamole_db'
)\gexec


\echo 'Database creation process complete.'

-- Connect to the database
\c guacamole_db

-- Dynamically execute all SQL files in the schema directory
\i /docker-entrypoint-initdb.d/001-create-schema.sql;
\i /docker-entrypoint-initdb.d/002-create-admin-user.sql;

-- Insert a new connection
DO $$
DECLARE
    v_connection_id INT; -- Use a variable with a unique name
BEGIN
    -- Insert a new connection and retrieve its ID
    INSERT INTO guacamole_connection (connection_name, protocol)
    VALUES ('Firefox VNC Automatic', 'vnc')
    RETURNING connection_id INTO v_connection_id;

    -- Insert connection parameters using the retrieved connection ID
    INSERT INTO guacamole_connection_parameter (connection_id, parameter_name, parameter_value)
    VALUES
        (v_connection_id, 'hostname', 'firefox_vnc'),
        (v_connection_id, 'port', '5900'),
        (v_connection_id, 'password', 'guacadmin');

    -- Grant permissions to the 'guacadmin' user for the new connection
    INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission)
    VALUES
        ((SELECT entity_id FROM guacamole_entity WHERE name='guacadmin' AND type='USER'), v_connection_id, 'READ');
END $$;
