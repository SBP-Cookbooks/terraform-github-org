resource "github_repository" "terraform-github-org" {
  name        = "terraform-github-org"
  description = "Terraform plan to manage the SBP-Cookbooks GitHub organisation."
  has_issues  = false
}
