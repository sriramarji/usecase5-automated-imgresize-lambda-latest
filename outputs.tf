output "source_bucket_name" {
  value = module.s3_buckets.source_bucket_name
}

output "destination_bucket_name" {
  value = module.s3_buckets.destination_bucket_name
}

output "sns_topic_arn" {
  value = module.sns_topic.topic_arn
}

output "lambda_function_name" {
  value = module.lambda_function.function_name
}
