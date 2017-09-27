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
  permission = "push"
}

resource "github_team_membership" "sbp_messageanalyzer-shoekstra" {
  team_id  = "${github_team.sbp_messageanalyzer_team.id}"
  username = "shoekstra"
  role     = "member"
}
