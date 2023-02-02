package test

import (
	"crypto/tls"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	url := terraform.Output(t, terraformOptions, "application_url")
	tlsConfig := tls.Config{InsecureSkipVerify: true}
	maxRetries := 20
	timeBetweenRetries := 5 * time.Second
	// Verify that we get back a 200 OK.
	http_helper.HttpGetWithRetryWithCustomValidation(t, "https://"+url, &tlsConfig, maxRetries, timeBetweenRetries, validate)
}

func validate(status int, _ string) bool {
	return status == 200
}
