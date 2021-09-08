## Terraform module for hosting a static website on AWS S3

### Prerequisites

* terraform 1
* go 1.16 or greater

### Example usage

Directory structure
```bash
.
├── content
│   ├── error.html
│   └── index.html
├── main.tf
```
main.tf
```terraform
module "static-web-site" {
  source       = "norrbom/website/static"
  version      = "0.3.6"
  bucket       = "environment.myproject"
  policy       = {
    "Effect" = "Allow"
    "Principal" = "*"
    "Action" = "s3:GetObject"
  }
  policy_allowed_source_ip =["0.0.0.0/0"] # open to Internet
  logs_expiration_days = 180
}
```
### Test
Requires Go and Terraform
```bash
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_REGION=$AWS_REGION
./test/run.sh
```
Requires Docker
```bash
docker build -t terratest . && \
docker run --rm -it -v ${PWD}:/go/src \
-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
-e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
-e AWS_REGION=$AWS_REGION \
terratest \
sh /go/src/test/run.sh
```