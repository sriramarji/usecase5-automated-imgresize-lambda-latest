variable "lambda_function_name" {
    description = "lambda function name"
    type = string
}
variable "source_path" {}
variable "s3_bucket_arn" {}
variable "destination_bucket_name" {}
variable "sns_topic_arn" {}
