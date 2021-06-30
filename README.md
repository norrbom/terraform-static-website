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
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_REGION=$AWS_REGION
cd test
go mod init terraform-static-website-test
go mod tidy -v
go get .
go test -v
```