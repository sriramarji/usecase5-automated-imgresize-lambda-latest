# modules/lambda/main.tf
resource "aws_lambda_function" "image_processing" {
  function_name = var.lambda_function_name

  s3_bucket = var.lambda_code_bucket
  s3_key    = "lambda_code.zip"

  runtime = "nodejs14.x"
  handler = "lambda_function.handler"

  environment {
    variables = {
      S3_BUCKET_NAME = var.image_bucket_name
      SNS_TOPIC_ARN  = var.sns_topic_arn
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
        Resource = "${var.image_bucket_arn}/*"
      },
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = var.sns_topic_arn
      }
    ]
  })
}
