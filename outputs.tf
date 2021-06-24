output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket.b.website_endpoint
  description = "The website endpoint URL"
}
