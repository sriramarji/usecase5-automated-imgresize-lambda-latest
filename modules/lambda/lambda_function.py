import json
import boto3
from PIL import Image
import os
from io import BytesIO

s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    # Get the bucket and object key from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    
    # Get the image file from S3
    image_object = s3_client.get_object(Bucket=bucket_name, Key=object_key)
    image_data = image_object['Body'].read()

    # Open the image using PIL
    image = Image.open(BytesIO(image_data))

    # Resize the image (example: resize to 800x600)
    image = image.resize((800, 600))

    # Save resized image to a BytesIO object
    resized_image_io = BytesIO()
    image.save(resized_image_io, format='JPEG')
    resized_image_io.seek(0)

    # Define the key for the resized image
    resized_image_key = object_key.replace('input/', 'output/')

    # Upload the resized image back to S3
    s3_client.put_object(Bucket=bucket_name, Key=resized_image_key, Body=resized_image_io)

    # Send a notification via SNS
    sns_client.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message=f"Image {object_key} has been resized and uploaded to {resized_image_key}",
        Subject="Image Processing Completed"
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Image processing complete!')
    }
