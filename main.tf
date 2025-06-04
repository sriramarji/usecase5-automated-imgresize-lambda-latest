provider "aws" {
  region = "us-east-1"
}

module "lambda" {
  source = "./lambda"
}

module "s3" {
  source = "./s3"
}

module "sns" {
  source = "./sns"
}

# Trigger the Lambda function when an image is uploaded to S3
resource "aws_s3_bucket_object" "lambda_trigger" {
  bucket = aws_s3_bucket.image_processing_bucket.bucket
  key    = "images/input/"

  notification {
    lambda_function {
      events = ["s3:ObjectCreated:*"]
      filter_prefix = "images/input/"
      lambda_function_arn = aws_lambda_function.image_processing.arn
    }
  }
}
