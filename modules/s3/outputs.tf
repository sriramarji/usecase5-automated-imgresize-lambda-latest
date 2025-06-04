output "image_bucket_name" {
  value = aws_s3_bucket.image_processing_bucket.id
}

output "lambda_bucket_name" {
  value = aws_s3_bucket.lambda_code_bucket.id
}

output "image_bucket_arn" {
  value = aws_s3_bucket.image_processing_bucket.arn
}

output "destination_bucket_name" {
  value = aws_s3_bucket.destination_bucket.id
}

output "destination_bucket_arn" {
  value = aws_s3_bucket.destination_bucket.arn
}