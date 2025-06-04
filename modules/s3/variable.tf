variable "source_bucket_name" {
  type        = string
  description = "Bucket to store and process uploaded images"
}

variable "destination_bucket_name" {
  description = "S3 bucket name for resized image storage"
  type        = string
}

