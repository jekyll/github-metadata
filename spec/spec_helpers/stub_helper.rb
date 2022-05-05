# frozen_string_literal: true

module StubHelper
  include WebMockHelper

  # Returns all stubs created.
  def stub_all_api_requests
    reset_env_for_stubs
    stubs = {
      "/users/jekyll/repos?per_page=100&type=public"            => "owner_repos",
      "/repos/jekyll/github-metadata"                           => "repo",
      "/orgs/jekyll"                                            => "org",
      "/orgs/jekyll/public_members?per_page=100"                => "org_members",
      "/repos/jekyll/github-metadata/pages"                     => "repo_pages",
      "/repos/jekyll/github-metadata/releases?per_page=100"     => "repo_releases",
      "/repos/jekyll/github-metadata/contributors?per_page=100" => "repo_contributors",
      "/repos/jekyll/jekyll.github.io"                          => "not_found",
      "/repos/jekyll/jekyll.github.com"                         => "repo",
      "/repos/jekyll/jekyll.github.com/pages"                   => "repo_pages",
      "/repos/jekyll/jekyll.github.io/pages"                    => "repo_pages",
      "/repos/jekyll/github-metadata/releases/latest"           => "latest_release",
    }.map { |path, file| stub_api(path, file) }

    owner_repos = JSON.parse(webmock_data("owner_repos"))
    owner_repos.each do |r|
      stubs << stub_api("/repos/#{r["full_name"]}/releases?per_page=100", "repo_releases")
      stubs << stub_api("/repos/#{r["full_name"]}/contributors?per_page=100", "repo_contributors")
    end

    stubs
  end

  def reset_env_for_stubs
    # Reset some stuffs
    ENV["NO_NETRC"] = "true"
    ENV["JEKYLL_GITHUB_TOKEN"] = "1234abc"
    ENV["PAGES_REPO_NWO"] = "jekyll/github-metadata"
    ENV["PAGES_ENV"] = "dotcom"
  end
end
