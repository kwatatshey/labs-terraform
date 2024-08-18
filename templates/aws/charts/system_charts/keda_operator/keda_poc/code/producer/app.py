import os
import time
import boto3
import datetime

# Setting up AWS SQS client and retrieving the queue URL
sqs = boto3.client('sqs', region_name='eu-west-1')
sqs_queue_url = os.getenv("SQS_QUEUE_URL")

def get_queue_length():
    """Get the approximate number of messages in the SQS queue."""
    attrs = sqs.get_queue_attributes(
        QueueUrl=sqs_queue_url,
        AttributeNames=['ApproximateNumberOfMessages']
    )
    return int(attrs['Attributes']['ApproximateNumberOfMessages'])

def send_messages():
    """Produce messages at varying rates and send them to SQS."""
    sent_count = 0
    delay = 1.0  # Start with a 1-second delay

    while True:
        # Stop after producing 150 messages
        if sent_count >= 150:
            print(f"[{datetime.datetime.now()}] Producer --> Reached 150 messages, stopping production.")
            break

        print(f"[{datetime.datetime.now()}] Producer --> Sending message to SQS")
        sqs.send_message(
            QueueUrl=sqs_queue_url,
            MessageBody=f'Producer --> Hello from the producer! {sent_count}'
        )
        sent_count += 1

        # Adjust delay based on the number of messages sent
        if sent_count >= 150:
            delay = 0.4
        elif sent_count >= 100:
            delay = 0.6
        elif sent_count >= 50:
            delay = 0.8
        else:
            delay = 1.0

        time.sleep(delay)

if __name__ == "__main__":
    # Run the producer application standalone
    send_messages()
