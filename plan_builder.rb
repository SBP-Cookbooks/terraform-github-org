#!/usr/bin/env ruby
#
# Simple ruby script to build TF plans for repositories and user access
#
# Stephen Hoekstra <shoekstra@schubergphilis.com>
#

def cookbook_repo(name, description, members)
  content = []
  content << resource_github_repository(name, description)
  content << resource_github_team(name)
  content << resource_github_team_repository(name)
  members.sort.each do |member|
    content << resource_github_team_membership(name, member)
  end

  write_file_if_updated("#{name}.tf", content.flatten.join("\n"))
end

def resource_github_membership(members)
  content = []
  members.sort.each do |member|
    next if File.open('admins.tf').read.include? member
    content << [
      "resource \"github_membership\" \"#{member}\" {",
      "  username = \"#{member}\"",
      '  role     = "member"',
      "}",
      "",
    ]
  end
  write_file_if_updated('members.tf', content.flatten.join("\n"))
end

def resource_github_repository(name, short_description = nil, description = nil, has_issues = true)
  if short_description && description.nil?
    description = "Development repository for the #{short_description} cookbook - https://supermarket.chef.io/cookbooks/#{name}"
  end
  [
    "resource \"github_repository\" \"#{name}\" {",
    "  name        = \"#{name}\"",
    "  description = \"#{description}\"",
    "  has_issues  = #{has_issues}",
    '}',
    ''
  ].join "\n"
end

def resource_github_team(name)
  [
    "resource \"github_team\" \"#{name}_team\" {",
    "  name        = \"#{name}\"",
    "  description = \"#{name} Cookbook Maintainers\"",
    '  privacy     = "closed"',
    '}',
    ''
  ].join "\n"
end

def resource_github_team_membership(team, username)
  [
    "resource \"github_team_membership\" \"#{team}-#{username}\" {",
    "  team_id  = \"${github_team.#{team}_team.id}\"",
    "  username = \"#{username}\"",
    '  role     = "member"',
    '}',
    ''
  ].join "\n"
end

def resource_github_team_repository(name, team = nil)
  team ||= name
  [
    "resource \"github_team_repository\" \"#{name}_repo\" {",
    "  team_id    = \"${github_team.#{team}_team.id}\"",
    "  repository = \"#{name}\"",
    '  permission = "push"',
    '}',
    ''
  ].join "\n"
end

def tf_repo(repos)
  content = []
  content << resource_github_repository('terraform-github-org', nil, 'Terraform plan to manage the SBP-Cookbooks GitHub organisation.', false)
  write_file_if_updated('terraform-github-org.tf', content.flatten.join("\n"))
end

def write_file_if_updated(file, content)
  return if File.open(file).read.eql? content

  puts "Writing updated #{file}..."
  File.write(file, content)
end

require 'yaml'

config = YAML::load_file('config.yaml')

tf_repo config['repos']

config['repos'].each do |repo|
  members = []
  config['users'].each do |user|
    members << user['name'] if Array(user['repos']).grep(/#{repo['name']}|all/)
  end
  cookbook_repo(repo['name'], repo['description'], members.sort)
end

resource_github_membership(config['users'].map { |user| user['name'] })
