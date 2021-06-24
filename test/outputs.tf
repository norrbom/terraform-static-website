output "s3_bucket_website_endpoint" {
  value       = module.static-web-site.s3_bucket_website_endpoint
  description = "The website endpoint URL"
}
