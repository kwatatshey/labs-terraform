-- Give access to airflow database objects to airflow_read user
GRANT USAGE ON SCHEMA public TO airflow_role_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO airflow_role_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO airflow_role_readonly;