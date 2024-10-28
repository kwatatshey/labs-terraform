-- Create role and user airflow_read
CREATE ROLE airflow_role_readonly;
CREATE USER airflow_read WITH PASSWORD :airflow_read_password;
GRANT airflow_role_readonly TO airflow_read;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT CREATE ON SCHEMA public TO airflow;