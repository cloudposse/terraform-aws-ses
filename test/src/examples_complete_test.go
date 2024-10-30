package test

import (
	"fmt"
	"math/rand"
	"os/exec"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var letterRunes = []rune("abcdefghijklmnopqrstuvwxyz1234567890")

func detectPlatform() string {
	cmd := exec.Command("terraform", "--version")
	out, _ := cmd.CombinedOutput()
	platform := ""
	if strings.Contains(string(out), "Terraform") {
		platform = "tf"
	} else if strings.Contains(string(out), "OpenTofu") {
		platform = "tofu"
	} else {
		platform = "unknown"
	}
	return platform
}

func RandStringRunes(n int) string {
	rand.Seed(time.Now().UnixNano())
	b := make([]rune, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	// This test is not isolated enough to run in parallel
	// t.Parallel()

	testName := "ses-test-" + RandStringRunes(10)
	platform := detectPlatform()
	attributes := []string{platform}
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"name":       testName,
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	userName := terraform.Output(t, terraformOptions, "user_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, fmt.Sprintf("eg-test-ses-%s", platform), userName)
}
