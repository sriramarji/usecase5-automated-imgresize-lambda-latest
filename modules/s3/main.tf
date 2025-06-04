# modules/s3/main.tf
resource "aws_s3_bucket" "image_processing_bucket" {
  bucket = var.image_bucket_name

  versioning {
    enabled = true
  }

  tags = {
    Name        = "image-processing-bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = var.destination_bucket_name

  versioning {
    enabled = true
  }

  tags = {
    Name = var.destination_bucket_name
    Type = "Image Destination"
  }
}


resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = var.lambda_bucket_name

  versioning {
    enabled = true
  }
}
