## Terraform module for hosting a static website on AWS S3
### Example usage

Directory structure
```bash
.
├── content
│   ├── error.html
│   └── index.html
├── main.tf
```
main.tf
```terraform
module "static-web-site" {
  source       = "../"
  bucket       = "environment.myproject"
  policy       = {
    "Effect" = "Allow"
    "Principal" = "*"
    "Action" = "s3:GetObject"
  }
  policy_allowed_source_ip =["0.0.0.0/0"] # open to Internet
}
```
### Test
```bash
export PARAMETERS="--terragrunt-working-dir ./test --terragrunt-non-interactive -auto-approve"
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
terragrunt apply $PARAMETERS
# retrieve the website endpoint
terraform -chdir=./test output s3_bucket_website_endpoint
terragrunt destroy $PARAMETERS
```