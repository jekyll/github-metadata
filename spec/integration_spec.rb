require "spec_helper"
require "jekyll"

RSpec.describe("integration into a jekyll site") do
  SOURCE_DIR = Pathname.new(File.expand_path("../test-site", __FILE__))
  DEST_DIR = Pathname.new(File.expand_path("../../tmp/test-site-build", __FILE__))

  def dest_dir(*files)
    DEST_DIR.join(*files)
  end

  before(:all) do
    # Stub Requests
    stub_api("/users/jekyll/repos\?per_page=100&type=public", "owner_repos")
    stub_api("/repos/jekyll/github-metadata", "repo")
    stub_api("/repos/jekyll/github-metadata/contributors", "repo_contributors")
    stub_api("/repos/jekyll/github-metadata/releases", "repo_releases")
    stub_api("/orgs/jekyll", "org")

    # Run Jekyll
    Jekyll.logger.log_level = :error
    Jekyll::Commands::Build.process({
      "source" => SOURCE_DIR.to_s,
      "destination" => DEST_DIR.to_s,
      "gems" => %w{jekyll-github-metadata},
      "repository" => "jekyll/github-metadata"
    })
  end
  subject { SafeYAML::load(dest_dir("rendered.txt").read) }

  it "prints" do
    SPEC_DIR.join("webmock/api_success.json").write(JSON.dump(subject))
  end
  {
    "environment"          => "development",
    "hostname"             => "https://github.com",
    "pages_hostname"       => "github.io",
    "api_url"              => "https://api.github.com",
    "versions"             => defined?(GitHubPages) ? GitHubPages.versions : {},
    "public_repositories"  => Regexp.new('"id"=>17261694, "name"=>"atom-jekyll"'),
    "organization_members" => Regexp.new('"login"=>"parkr", "id"=>237985'),
    "build_revision"       => /[a-f0-9]{40}/,
    "project_title"        => "github-metadata",
    "project_tagline"      => ":octocat: `site.github`",
    "owner_name"           => "jekyll",
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
    "url"                  => "http://jekyll.github.io/github-metadata/",
    "contributors"         => /"login"=>"parkr", "id"=>237985/,
    "releases"             => /"tag_name"=>"v1.1.0"/,
  }.each do |key, value|
    it "contains the correct #{key}" do
      expect(subject).to have_key(key)
      if value.is_a? Regexp
        expect(subject[key].to_s).to match value
      else
        expect(subject[key]).to eql value
      end
    end
  end

end
