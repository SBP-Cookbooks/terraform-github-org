resource "github_repository" "sbp_mcafee" {
  name        = "sbp_mcafee"
  description = "Development repository for the McAfee cookbook - https://supermarket.chef.io/cookbooks/sbp_mcafee"
  has_issues  = true
}

resource "github_team" "sbp_mcafee_team" {
  name        = "sbp_mcafee"
  description = "sbp_mcafee Cookbook Maintainers"
  privacy     = "closed"
}

resource "github_team_repository" "sbp_mcafee_repo" {
  team_id    = "${github_team.sbp_mcafee_team.id}"
  repository = "sbp_mcafee"
  permission = "push"
}

resource "github_team_membership" "sbp_mcafee-shoekstra" {
  team_id  = "${github_team.sbp_mcafee_team.id}"
  username = "shoekstra"
  role     = "member"
}
