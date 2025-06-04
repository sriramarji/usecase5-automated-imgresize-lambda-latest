variable "function_name" {
    description = "lambda function name"
    type = string
}
variable "pillow_layer_zip" {
  description = "Path to Pillow layer zip"
  type        = string
}
variable "source_path" {}
variable "s3_bucket_arn" {}
variable "destination_bucket_name" {}
variable "sns_topic_arn" {}
variable "handler" {}
variable "runtime" {}
variable "source_bucket_name" {}

