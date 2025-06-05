import os
import boto3
from PIL import Image
from io import BytesIO

# Initialize AWS clients
s3 = boto3.client('s3')
sns = boto3.client('sns')

# Load from environment variables
source_bucket = os.environ['SOURCE_BUCKET']
destination_bucket = os.environ['DESTINATION_BUCKET']
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    if 'Records' in event:
        for record in event['Records']:
            process_image(record)
    else:
        print("No 'Records' in event:", event)
        return {"error": "Invalid event format"}

def process_image(record):
    try:
        key = record['s3']['object']['key']
        response = s3.get_object(Bucket=source_bucket, Key=key)
        content_type = response.get('ContentType', 'image/jpeg')  # default fallback
        image_data = response['Body'].read()

        # Resize the image
        image = Image.open(BytesIO(image_data))
        image = image.resize((800, 600))  # Fixed resize
        buffer = BytesIO()
        image.save(buffer, format=image.format if image.format else 'JPEG', quality=75)
        buffer.seek(0)

        # Upload to destination bucket
        destination_key = f"resized/{key}"
        s3.put_object(Bucket=destination_bucket, Key=destination_key, Body=buffer, ContentType=content_type)

        # Notify via SNS
        message = f"Image {key} has been resized and uploaded to {destination_bucket}"
        sns.publish(TopicArn=sns_topic_arn, Message=message)
    except Exception as e:
        print("Error processing image:", str(e))
