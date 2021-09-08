terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  content_type_map = {
    html = "text/html",
    js   = "application/javascript",
    css  = "text/css",
    svg  = "image/svg+xml",
    jpg  = "image/jpeg",
    ico  = "image/x-icon",
    png  = "image/png",
    gif  = "image/gif",
    pdf  = "application/pdf"
  }
}

resource "random_string" "bucket_name" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket != null ? "log-bucket-${var.bucket}" : "log-bucket-${random_string.bucket_name.result}"
  acl    = "log-delivery-write"

  lifecycle_rule {
    id      = "logs"
    enabled = true
    prefix  = "logs/"
    expiration {
      days = var.logs_expiration_days
    }
  }
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket != null ? var.bucket : "static-website-${random_string.bucket_name.result}"
  acl    = var.acl

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "logs/"
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_s3_bucket.b.id}-policy"
    Statement = [
      {
        "Effect"    = var.policy["Effect"]
        "Principal" = var.policy["Principal"]
        "Action"    = var.policy["Action"]
        Resource = [
          aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.policy_allowed_source_ip
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_object" "b" {
  for_each     = fileset(var.content_path, "content/*")
  bucket       = aws_s3_bucket.b.id
  key          = replace(each.value, "content/", "")
  content_type = lookup(local.content_type_map, regex("\\.(?P<extension>[A-Za-z0-9]+)$", each.value).extension, "application/octet-stream")
  source       = each.value
  etag         = filemd5(each.value)
  depends_on = [
    aws_s3_bucket.b
  ]
}
