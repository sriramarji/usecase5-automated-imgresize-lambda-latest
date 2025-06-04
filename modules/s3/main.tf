resource "aws_s3_bucket" "source" {
  bucket = "${var.source_bucket_name}-${random_pet.this.id}"

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket" "destination" {
  bucket = "${var.destination_bucket_name}-${random_pet.this.id}"

  versioning {
    enabled = true
  }
}

resource "random_pet" "this" {
  length = 2
}

