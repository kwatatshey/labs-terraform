-- Create user airflow and database airflow
CREATE USER airflow PASSWORD :airflow_password;
CREATE DATABASE airflow;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow;