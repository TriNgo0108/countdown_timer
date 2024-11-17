provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "bootstrap" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Production"
  }
   
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.bootstrap.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "countdown_timer_website_configuration" {
  bucket = aws_s3_bucket.bootstrap.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.bootstrap.id

  # Policy to allow public read access to all objects in the bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.bootstrap.bucket}/*"
      }
    ]
  })
}

terraform {
  backend "s3" {
    bucket = "countdown-timer-core-terraform-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}