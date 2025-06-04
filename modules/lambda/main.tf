# modules/lambda/main.tf
resource "aws_lambda_function" "image_processing" {
  function_name = "image-processing-function"

  s3_bucket = aws_s3_bucket.lambda_code_bucket.bucket
  s3_key    = "lambda_code.zip"

  runtime = "nodejs14.x"
  handler = "lambda_function.handler"

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.image_processing_bucket.bucket
      SNS_TOPIC_ARN  = aws_sns_topic.image_processing_topic.arn
    }
  }

  role = aws_iam_role.lambda_execution_role.arn
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.image_processing_bucket.arn}/*"
      },
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = aws_sns_topic.image_processing_topic.arn
      }
    ]
  })
}
