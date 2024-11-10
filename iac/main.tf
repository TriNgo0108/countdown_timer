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

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}_terraform_state"
   tags = {
    Name        = "${var.bucket_name}_terraform_state"
    Environment = "Production"
  }
}

resource "aws_s3_object" "files" {
  for_each = fileset(var.src_folder, "**")
  bucket = aws_s3_bucket.bootstrap.id
  key    = each.value
  source = "${var.src_folder}/${each.value}"
  etag   = filemd5("${var.src_folder}/${each.value}")
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.bootstrap.id
  block_public_acls       = false
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
    bucket = "countdown_timer_terraform_state"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}