variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = "countdown-timer-core"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "index_document" {
  description = "Index document for the website"
  type        = string
  default     = "index.html"
}

variable "src_folder" {
  description = "source application"
  type = string
  default = "../src"
}

variable "content_type_map" {
  type = map(string)
  default = {
    ".html"  = "text/html"
    ".css"   = "text/css"
    ".js"    = "application/javascript"
    ".json"  = "application/json"
    ".png"   = "image/png"
    ".jpeg"  = "image/jpeg"
    ".jpg"   = "image/jpeg"
    ".gif"   = "image/gif"
    ".svg"   = "image/svg+xml"
    ".woff2" = "application/font-woff2"
  }
}

