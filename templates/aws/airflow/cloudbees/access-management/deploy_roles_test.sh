#!/bin/bash

# Script to deploy Airflow roles through API from .json definitions (version for Cloudbees)
# Params:
# API URL: Full url to roles endpoint on target Airflow instance e.g. https://mantisairfloweng.merck.com/api/v1/roles
# ROLES: List of roles to be deployed. Separated by a space. E.g. msd_op_dev msd_user_dev msd_viewer_dev
# Username and password: LDAP account that has permission to create Airflow roles

API_URL=$1
USERVAR=$2
PASSVAR=$3
ROLES=$4
ROLES_ARRAY=(${ROLES// / })

echo -e "API_URL=$API_URL"
echo -e "ROLES=$ROLES"

for ROLE in "${ROLES_ARRAY[@]}"; do
  echo "Deploying role $ROLE"
  echo "Our file=${ROLE}.json, its content:"
  cat ./role-definitions/$ROLE.json
  #curl -X POST -H 'content-type: application/json' -d @./role-definitions/$ROLE.json "${API_URL}" --user "${USERVAR}:${PASSVAR}"
done
