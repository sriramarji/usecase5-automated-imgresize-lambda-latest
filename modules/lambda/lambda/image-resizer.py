import os
import boto3
from PIL import Image
from io import BytesIO

s3 = boto3.client('s3')
sns = boto3.client('sns')

source_bucket = os.environ['SOURCE_BUCKET']
destination_bucket = os.environ['DESTINATION_BUCKET']
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    for record in event['Records']:
        key = record['s3']['object']['key']
        response = s3.get_object(Bucket=source_bucket, Key=key)
        image_data = response['Body'].read()
        image = Image.open(BytesIO(image_data))
        image = image.resize((800, 600))  # Example resize
        buffer = BytesIO()
        image.save(buffer, format='JPEG')
        buffer.seek(0)
        s3.put_object(Bucket=destination_bucket, Key=f"resized/{key}", Body=buffer)
        sns.publish(TopicArn=sns_topic_arn, Message=f"Image {key} has been resized and uploaded.")
