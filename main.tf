module "s3_buckets" {
  source = "./modules/s3"
  source_bucket_name      = var.source_bucket_name
  destination_bucket_name = var.destination_bucket_name
}

module "sns_topic" {
  source = "./modules/sns"
  topic_name = var.sns_topic_name
  notification_email = var.notification_email
}

module "lambda_function" {
  source = "./modules/lambda"
  function_name        = var.lambda_function_name
  handler              = "image-resizer.lambda_handler"
  runtime              = "python3.9"
  source_path          = "${path.module}/lambda/image-resizer.py"
  pillow_layer_zip     = "${path.module}/pillow-layer.zip"
  source_bucket_name   = module.s3_buckets.source_bucket_name
  destination_bucket_name = module.s3_buckets.destination_bucket_name
  sns_topic_arn        = module.sns_topic.topic_arn
  s3_bucket_arn        = module.s3_buckets.source_bucket_arn
}
