const AWS = require('aws-sdk');
const sharp = require('sharp');  // Image processing library for resizing
const s3 = new AWS.S3();
const sns = new AWS.SNS();

const bucketName = process.env.S3_BUCKET_NAME;
const snsTopicArn = process.env.SNS_TOPIC_ARN;

exports.handler = async (event) => {
  const bucket = event.Records[0].s3.bucket.name;
  const key = event.Records[0].s3.object.key;

  try {
    // Fetch the image from S3
    const originalImage = await s3.getObject({ Bucket: bucket, Key: key }).promise();

    // Resize the image using sharp (800x600 pixels)
    const resizedImage = await sharp(originalImage.Body)
      .resize(800, 600)
      .toBuffer();

    // Define the new key for the resized image
    const resizedKey = key.replace('input/', 'output/');

    // Upload the resized image to S3
    await s3.putObject({
      Bucket: bucket,
      Key: resizedKey,
      Body: resizedImage,
      ContentType: 'image/jpeg',  // You can change this depending on your image type
    }).promise();

    // Send SNS notification
    await sns.publish({
      Message: `Image ${key} has been resized and saved as ${resizedKey}`,
      Subject: 'Image Processing Completed',
      TopicArn: snsTopicArn,
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify('Image processed successfully!'),
    };
  } catch (err) {
    console.error('Error processing image:', err);
    throw new Error('Error processing image');
  }
};
