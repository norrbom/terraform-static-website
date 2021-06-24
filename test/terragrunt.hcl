remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-static-website-test-843whjoef"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table-static-website-test-843whjoef"
  }
}
