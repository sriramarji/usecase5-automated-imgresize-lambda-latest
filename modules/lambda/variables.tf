variable "lambda_function_name" {
    description = "lambda function name"
    type = string
}
variable "image_bucket_name" {}
variable "image_bucket_arn" {}
variable "destination_bucket_name" {}
variable "sns_topic_arn" {}
