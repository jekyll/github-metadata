require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/ghp_metadata_generator"

RSpec.describe("integration into a jekyll site") do
  SOURCE_DIR = Pathname.new(File.expand_path("../test-site", __FILE__))
  DEST_DIR = Pathname.new(File.expand_path("../../tmp/test-site-build", __FILE__))

  def dest_dir(*files)
    DEST_DIR.join(*files)
  end

  API_STUBS = {
    "/users/jekyll/repos?per_page=100"                        => "owner_repos",
    "/repos/jekyll/github-metadata"                           => "repo",
    "/orgs/jekyll"                                            => "org",
    "/orgs/jekyll/public_members?per_page=100"                => "org_members",
    "/repos/jekyll/github-metadata/pages"                     => "repo_pages",
    "/repos/jekyll/github-metadata/releases?per_page=100"     => "repo_releases",
    "/repos/jekyll/github-metadata/contributors?per_page=100" => "repo_contributors",
    "/repos/jekyll/jekyll.github.io"                          => "not_found",
    "/repos/jekyll/jekyll.github.com"                         => "repo",
    "/repos/jekyll/jekyll.github.com/pages"                   => "repo_pages",
    "/repos/jekyll/jekyll.github.io/pages"                    => "repo_pages"
  }.map { |path, file| ApiStub.new(path, file) }

  before(:each) do
    # Reset some stuffs
    ENV["NO_NETRC"] = "true"
    ENV["JEKYLL_GITHUB_TOKEN"] = "1234abc"
    ENV["PAGES_REPO_NWO"] = "jekyll/github-metadata"
    ENV["PAGES_ENV"] = "dotcom"

    # Stub Requests
    API_STUBS.each { |stub| stub.stub = stub_api(stub.path, stub.file) }

    # Run Jekyll
    Jekyll.logger.log_level = :error
    Jekyll::Commands::Build.process({
      "source"      => SOURCE_DIR.to_s,
      "destination" => DEST_DIR.to_s,
      "gems"        => %w(jekyll-github-metadata)
    })
  end
  subject { SafeYAML.load(dest_dir("rendered.txt").read) }

  {
    "environment"          => "dotcom",
    "hostname"             => "github.com",
    "pages_env"            => "dotcom",
    "pages_hostname"       => "github.io",
    "help_url"             => "https://help.github.com",
    "api_url"              => "https://api.github.com",
    "versions"             => {},
    "public_repositories"  => Regexp.new('"id"=>17261694, "name"=>"atom-jekyll"'),
    "organization_members" => Regexp.new('"login"=>"parkr", "id"=>237985'),
    "build_revision"       => %r![a-f0-9]{40}!,
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
    "url"                  => "http://jekyll.github.io/github-metadata",
    "contributors"         => %r!"login"=>"parkr", "id"=>237985!,
    "releases"             => %r!"tag_name"=>"v1.1.0"!
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

  it "calls all the stubs" do
    API_STUBS.each do |stub|
      expect(stub.stub).to have_been_requested
    end
  end
end
