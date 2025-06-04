# main.tf
provider "aws" {
  region = "us-east-1"
}

module "lambda" {
  source = "./modules/lambda"
}

module "s3" {
  source = "./modules/s3"
}

module "sns" {
  source = "./modules/sns"
}

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
