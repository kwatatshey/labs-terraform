#!/bin/bash

# Script to deploy Airflow roles through API from .json definitions
# Params:
# API URL: Full url to roles endpoint on target Airflow instance e.g. https://mantisairfloweng.merck.com/api/v1/roles
# ROLES: List of roles to be deployed. Separated by a space. E.g. msd_op_dev msd_user_dev msd_viewer_dev
# Username and password: LDAP account that has permission to create Airflow roles


read -p 'API role endpoint full url: ' API_URL
read -a ROLES -p 'Roles to deploy separated by space: '
read -p 'Username: ' USERVAR
read -sp 'Password: ' PASSVAR


for i in "${ROLES[@]}"; do
  echo "Deploying role $i"
  curl -X POST -H 'content-type: application/json' -d @./role-definitions/$i.json $API_URL --user $USERVAR:$PASSVAR
done
