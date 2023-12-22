# frozen_string_literal: true

module IntegrationHelper
  def expected_values
    {
      "environment"          => "dotcom",
      "hostname"             => "github.com",
      "pages_env"            => "dotcom",
      "pages_hostname"       => "github.io",
      "help_url"             => "https://docs.github.com",
      "api_url"              => "https://api.github.com",
      "versions"             => {},
      "public_repositories"  => Regexp.new('"id"=>17261694, "name"=>"atom-jekyll"'),
      "organization_members" => Regexp.new('"login"=>"parkr", "id"=>237985'),
      "build_revision"       => %r![a-f0-9]{40}!,
      "project_title"        => "github-metadata",
      "project_tagline"      => ":octocat: `site.github`",
      "owner"                => Regexp.new('"html_url"=>"https://github.com/jekyll",\s+"id"=>3083652'),
      "owner_name"           => "jekyll",
      "owner_display_name"   => "Jekyll",
      "owner_url"            => "https://github.com/jekyll",
      "owner_gravatar_url"   => "https://github.com/jekyll.png",
      "repository_url"       => "https://github.com/jekyll/github-metadata",
      "repository_nwo"       => "jekyll/github-metadata",
      "repository_name"      => "github-metadata",
      "zip_url"              => "https://github.com/jekyll/github-metadata/zipball/gh-pages",
      "tar_url"              => "https://github.com/jekyll/github-metadata/tarball/gh-pages",
      "clone_url"            => "https://github.com/jekyll/github-metadata.git",
      "releases_url"         => "https://github.com/jekyll/github-metadata/releases",
      "issues_url"           => "https://github.com/jekyll/github-metadata/issues",
      "wiki_url"             => nil, # disabled
      "language"             => "Ruby",
      "is_user_page"         => false,
      "is_project_page"      => true,
      "show_downloads"       => true,
      "url"                  => "http://jekyll.github.io/github-metadata",
      "baseurl"              => "/github-metadata",
      "contributors"         => %r!"login"=>"parkr", "id"=>237985!,
      "releases"             => %r!"tag_name"=>"v1.1.0"!,
      "latest_release"       => %r!assets_url!,
      "private"              => false,
      "archived"             => false,
      "disabled"             => false,
      "license"              => %r!"key"=>"mit"!,
      "source"               => { "branch" => "gh-pages", "path" => "/" },
    }
  end
end
