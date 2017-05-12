# terraform-github-org

For managing the [Schuberg Philis Cookbook](https://github.com/sbp-cookbooks) GitHub organisation.
<br>
<br>
## Usage

This repository is used to manage repositories and memberships in the [sbp-cookbooks](https://github.com/sbp-cookbooks) org. Changes in a pull request will be applied by a Travis CI job once merged to master - do not run terraform manually!
<br>
<br>
### Becoming a member of sbp-cookbooks

Eventually Okta will provision all employees into this organisation, until then you will need to add yourself to the `members.tf` file:

```
resource "github_membership" "YOUR_USERNAME" {
  username = "YOUR_USERNAME"
  role     = "member"
}
```

Commit your changes:

```
$ git commit members.tf -m 'Add YOUR_USERNAME'
```

Create PR against this repository, someone will review and merge and Travis will create the repository and team for you.
<br>
<br>
### Creating a repository

Create a new file named after your repository, e.g. `sbp_messageanalyzer.tf`.  It should contain:

```
resource "github_repository" "sbp_messageanalyzer" {
  name        = "sbp_messageanalyzer"
  description = "Development repository for the Message Analyzer cookbook - https://supermarket.chef.io/cookbooks/sbp_messageanalyzer"
  has_issues  = true
}

resource "github_team" "sbp_messageanalyzer_team" {
  name        = "sbp_messageanalyzer"
  description = "sbp_messageanalyzer Cookbook Maintainers"
  privacy     = "closed"
}

resource "github_team_repository" "sbp_messageanalyzer_repo" {
  team_id    = "${github_team.sbp_messageanalyzer_team.id}"
  repository = "sbp_messageanalyzer"
  permission = "admin"
}

resource "github_team_membership" "sbp_messageanalyzer-YOUR_USERNAME" {
  team_id  = "${github_team.sbp_messageanalyzer_team.id}"
  username = "YOUR_USERNAME"
  role     = "maintainer"
}
```

Commit your changes:

```
$ git commit sbp_messageanalyzer.tf -m 'Add sbp_messageanalyzer repository'
```

Create PR against this repository, someone will review and merge and Travis will create the repository and team for you.

