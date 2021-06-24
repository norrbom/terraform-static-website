resource "random_string" "bucket_name" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket != null ? var.bucket : "static-website-${random_string.bucket_name.result}"
  acl    = var.acl

  website {
    index_document = "index.html"
    error_document = "error.html"
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
  content_type = "text/html"
  source       = each.value
  etag         = filemd5(each.value)
  depends_on = [
    aws_s3_bucket.b
  ]
}
