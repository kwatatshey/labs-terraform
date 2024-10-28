import json
import requests
import boto3

import boto3
import json

def getApiKey():
    # Create a Secrets Manager client
    client = boto3.client('secretsmanager')
    api_key = ""

    # Retrieve the secret value from Secrets Manager
    try:
        response = client.get_secret_value(SecretId='aparflow/airflowfdna/moogsoft')
    except Exception as e:
        print("Error retrieving secret:", e)
        return api_key

    # Parse and extract the API key from the secret value
    try:
        secret = json.loads(response['SecretString'])
        api_key = secret['api_key']
    except KeyError as e:
        print("API key not found in secret:", e)
    
    return api_key


def lambda_handler(event, context):
    print("SNS event:", event)
    sns_message = json.loads(event['Records'][0]['Sns']['Message'])
    for alert in sns_message['alerts']:
        if alert['status'] == "firing":
            send(alert)
        else:
            print("Not sending alert with state of resolved")


def send(alert):
    environment = alert['labels']['environment']
    alertname = alert['labels']['alertname']
    pod = alert['labels']['pod']
    region = alert['labels']['region']
    print("Alert Value:", alert)
    print("Alert Environment Value:", environment)
    hostname = ""
    severity = ""
    if environment == "development":
        hostname = "aparflow-EKS-Development"
        severity = "WARNING"
    elif environment == "testing":
        hostname = "aparflow-EKS-Test"
        severity = "MINOR"
    elif environment == "uat":
        hostname = "aparflow-EKS-UAT"
        severity = "MINOR"
    elif environment == "production":
        hostname = "aparflow-EKS-Production"
        severity = "MAJOR"
    else:
        hostname = "aparflow-grafana-unknown"
        severity = "UNKNOWN"

    alert_description = json.dumps(alert, indent=2)

    # Construct the payload for the Moogsoft API
    moogsoft_payload = {
        "description": alert_description,
        "severity": severity,
        "hostname": hostname,
        "type": alertname,
        "groupName": "ENT AWS Platform Support",
        "state": "open",
        "manager": "AMS-Grafana-Alerts",
        "class": pod,
        "uniqueId": "ams-grafana-g-56302bd32c",
        "agentLocation": region,
    }

    # Specify the Moogsoft API endpoint for the specified ingestion service
    api_endpoint = "https://iapi.merck.com/alert-management/v2/ingestion-services/webhook1/alerts"

    # Specify your Moogsoft API key
    api_key = getApiKey()

   # Check if the API key is empty or not
    if not api_key:
        print("API key is empty or not found")
        return

    # Set headers for the API request
    headers = {
        "Content-Type": "application/json",
        "X-Merck-APIKey": api_key
    }

    # Make a POST request to create a new alert in Moogsoft
    response = requests.post(api_endpoint, json=moogsoft_payload, headers=headers)

    # Check the response status
    if response.status_code == 201:
        print("Alert created successfully in Moogsoft.")
    else:
        print(f"Failed to create alert in Moogsoft. Status code: {response.status_code}, Response: {response.text}")
