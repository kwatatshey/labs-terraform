import os
import time
import boto3
import datetime

# Setting up AWS SQS client and retrieving the queue URL
sqs = boto3.client('sqs', region_name='eu-west-1')
sqs_queue_url = os.getenv("SQS_QUEUE_URL")

def consume_messages():
    """Consume messages from the SQS queue in a continuous loop."""
    while True:
        print(f"[{datetime.datetime.now()}] Consumer --> Checking for messages...")
        
        response = sqs.receive_message(
            QueueUrl=sqs_queue_url,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=20
        )

        messages = response.get('Messages', [])
        if not messages:
            print(f"[{datetime.datetime.now()}] Consumer --> No messages found. Waiting to check again...")
            time.sleep(10)
            continue

        for message in messages:
            print(f"[{datetime.datetime.now()}] Consumer --> Consuming message: {message['Body']}")
            sqs.delete_message(
                QueueUrl=sqs_queue_url,
                ReceiptHandle=message['ReceiptHandle']
            )

        print(f"[{datetime.datetime.now()}] Consumer --> Finished consuming messages. Checking again...")
if __name__ == "__main__":
    # Run the consumer application standalone
    consume_messages()