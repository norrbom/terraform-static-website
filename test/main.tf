module "static-web-site" {
  source = "../"
  policy = {
    "Effect"    = "Allow"
    "Principal" = "*"
    "Action"    = "s3:GetObject"
  }
  policy_allowed_source_ip = ["0.0.0.0/0"]
}
