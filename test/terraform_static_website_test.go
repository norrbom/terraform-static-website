package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func TestTerraformStaticWebsite(t *testing.T) {
	// website::tag::1:: Construct the terraform options with default retryable errors to handle the most common
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./",
	})

	// static-website::tag::5:: At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// static-website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// static-website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected values.
	output := terraform.Output(t, terraformOptions, "s3_bucket_website_endpoint")
	url := fmt.Sprintf("http://%s", output)
	// static-website::tag::4:: Make an HTTP request to the instance and make sure we get back a 200 OK with the body "Hello, World!"
	http_helper.HttpGetWithRetry(t, url, nil, 200, "hello!", 5, 5*time.Second)
}
