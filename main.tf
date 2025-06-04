# main.tf
provider "aws" {
  region = "us-east-1"
}

module "lambda" {
  source = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  lambda_code_bucket   = module.s3.lambda_bucket_name
  lambda_code_key      = var.lambda_code_key
  image_bucket_name    = module.s3.image_bucket_name
  image_bucket_arn     = module.s3.image_bucket_arn
  sns_topic_arn        = module.sns.topic_arn
}

module "s3" {
  source = "./modules/s3"
  image_bucket_name   = var.image_bucket_name
  lambda_bucket_name  = var.lambda_bucket_name
}

module "sns" {
  source = "./modules/sns"
  topic_name = var.topic_name
  email      = var.notification_email
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
