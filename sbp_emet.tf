resource "github_repository" "sbp_emet" {
  name        = "sbp_emet"
  description = "Development repository for the Message Analyzer cookbook - https://supermarket.chef.io/cookbooks/sbp_emet"
  has_issues  = true
}

resource "github_team" "sbp_emet_team" {
  name        = "sbp_emet"
  description = "sbp_emet Cookbook Maintainers"
  privacy     = "closed"
}

resource "github_team_repository" "sbp_emet_repo" {
  team_id    = "${github_team.sbp_emet_team.id}"
  repository = "sbp_emet"
  permission = "admin"
}
