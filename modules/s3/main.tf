# s3.tf
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
