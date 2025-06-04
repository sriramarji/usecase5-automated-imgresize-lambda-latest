variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  default     = "image-non-sized-1"
}

variable "destination_bucket_name" {
  description = "Name of the destination S3 bucket"
  default     = "image-sized-1"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  default     = "image-resizing-topic"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "image-resizer-function"
}

variable "notification_email" {
  description = "Notification email for SNS topic"
  default     = "niyaz.hasanmohamed@hcltech.com"  # Replace with your email
}