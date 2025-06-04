# modules/s3/main.tf
resource "aws_s3_bucket" "image_processing_bucket" {
  bucket = "image-processing-bucket"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = "image-processing-bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "lambda-code-bucket"

  versioning {
    enabled = true
  }
}
