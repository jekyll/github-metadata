require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/site_github_munger"

RSpec.describe(Jekyll::GitHubMetadata::SiteGitHubMunger) do
  let(:source) { File.expand_path("test-site", __dir__) }
  let(:dest) { File.expand_path("../tmp/test-site-build", __dir__) }
  let(:github_namespace) { nil }
  let(:user_config) { { "github" => github_namespace } }
  let(:site) { Jekyll::Site.new(Jekyll::Configuration.from(user_config)) }
  subject { described_class.new(site) }
  let!(:stubs) { stub_all_api_requests }
  let(:unified_payload) { site.site_payload }

  context "generating" do
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      subject.munge!
      subject.inject_metadata!(unified_payload)
    end

    context "with site.github as nil" do
      it "sets site.github to the drop" do
        expect(unified_payload.site["github"]).to be_a(Liquid::Drop)
      end
    end

    context "without site.github" do
      let(:user_config) { {} }

      it "replaces site.github with the drop" do
        expect(unified_payload.site["github"]).to be_a(Liquid::Drop)
      end
    end

    context "with site.github as a non-hash" do
      let(:github_namespace) { "foo" }

      it "doesn't munge" do
        expect(unified_payload.site["github"]).to eql("foo")
      end
    end

    context "with site.github as a hash" do
      let(:github_namespace) { { "source" => { "branch" => "foo" } } }

      it "lets user-specified values override the drop" do
        expect(unified_payload.site["github"].invoke_drop("source")["branch"]).to eql("foo")
      end

      it "still sets other values" do
        expect(unified_payload.site["github"].invoke_drop("source")["path"]).to eql("/")
      end
    end

    context "with site.url set" do
      let(:user_config) { { "url" => "http://example.com" } }

      it "doesn't mangle site.url" do
        expect(site.config["url"]).to eql("http://example.com")
      end
    end

    context "with site.baseurl set" do
      let(:user_config) { { "baseurl" => "/foo" } }

      it "doesn't mangle site.url" do
        expect(site.config["baseurl"]).to eql("/foo")
      end
    end

    context "with site.baseurl set to ''" do
      let(:user_config) { { "baseurl" => "" } }

      it "doesn't mangle site.baseurl" do
        expect(site.config["baseurl"]).to eql("")
      end
    end

    context "with site.baseurl set to '/'" do
      let(:user_config) { { "baseurl" => "/" } }

      it "mangles site.url" do
        expect(site.config["baseurl"]).to eql("/github-metadata")
      end
    end

    context "without site.url set" do
      it "sets site.url" do
        expect(site.config["url"]).to eql("http://jekyll.github.io")
      end
    end

    context "without site.baseurl set" do
      it "sets site.baseurl" do
        expect(site.config["baseurl"]).to eql("/github-metadata")
      end
    end

    context "title and description" do
      context "with title and description set" do
        let(:user_config) do
          { "title" => "My title", "description" => "My description" }
        end

        it "respects the title and tagline" do
          expect(site.config["title"]).to eql("My title")
          expect(site.config["description"]).to eql("My description")
        end
      end

      it "sets the title and description" do
        expect(site.config["title"]).to eql("github-metadata")
        expect(site.config["description"]).to eql(":octocat: `site.github`")
      end
    end

    context "with name set, but no title" do
      let(:user_config) { { "name" => "My site name" } }

      it "respects the site name" do
        expect(site.config["name"]).to eql("My site name")
        expect(site.config["title"]).to be_nil
      end
    end

    context "with site name and title" do
      let(:user_config) { { "name" => "Name", "title" => "Title" } }

      it "respects the user's settings" do
        expect(site.config["name"]).to eql("Name")
        expect(site.config["title"]).to eql("Title")
      end
    end
  end

  context "generating repo for user with displayname" do
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      ENV["PAGES_REPO_NWO"] = "jekyllbot/jekyllbot.github.io"
      stub_api("/repos/jekyllbot/jekyllbot.github.io", "user_site")
      stub_api_404("/orgs/jekyllbot")
      stub_api("/users/jekyllbot", "user_with_displayname")
      subject.munge!
    end

    it "sets title to user's displayname" do
      expect(site.config["title"]).to eql("Jekyll Bot")
    end
  end

  context "generating repo for user without displayname" do
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      ENV["PAGES_REPO_NWO"] = "jekyllbot/jekyllbot.github.io"
      stub_api("/repos/jekyllbot/jekyllbot.github.io", "user_site")
      stub_api_404("/orgs/jekyllbot")
      stub_api("/users/jekyllbot", "user_without_displayname")
      subject.munge!
    end

    it "sets title to user's login" do
      expect(site.config["title"]).to eql("jekyllbot")
    end
  end

  context "generating repo for org with displayname" do
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      ENV["PAGES_REPO_NWO"] = "jekyll/jekyll.github.io"
      stub_api("/repos/jekyll/jekyll.github.io", "repo")
      stub_api("/orgs/jekyll", "org")
      subject.munge!
    end

    it "sets title to org's displayname" do
      expect(site.config["title"]).to eql("Jekyll")
    end
  end

  context "generating repo for org without displayname" do
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      ENV["PAGES_REPO_NWO"] = "jekyll/jekyll.github.io"
      stub_api("/repos/jekyll/jekyll.github.io", "repo")
      stub_api("/orgs/jekyll", "org_without_displayname")
      subject.munge!
    end

    it "sets title to org's login" do
      expect(site.config["title"]).to eql("jekyll")
    end
  end

  context "with a client with no credentials" do
    before(:each) do
      Jekyll::GitHubMetadata.client = Jekyll::GitHubMetadata::Client.new(:access_token => "")
    end

    it "does not fail upon call to #munge" do
      expect do
        subject.munge!
      end.not_to raise_error
    end

    it "sets the site.github config" do
      subject.inject_metadata!(unified_payload)
      expect(unified_payload.site["github"]).to be_instance_of(Jekyll::GitHubMetadata::MetadataDrop)
    end
  end

  context "with a client with bad credentials" do
    before(:each) do
      Jekyll::GitHubMetadata.client = Jekyll::GitHubMetadata::Client.new(:access_token => "1234abc")
      stub_request(:get, url("/repos/jekyll/github-metadata/pages"))
        .with(:headers => request_headers.merge(
          "Authorization" => "token 1234abc"
        ))
        .to_return(
          :status  => 401,
          :headers => WebMockHelper::RESPONSE_HEADERS,
          :body    => webmock_data("bad_credentials")
        )
    end

    it "fails loudly upon call to any drop method" do
      subject.munge!
      subject.inject_metadata!(unified_payload)
      expect do
        unified_payload.site["github"]["url"]
      end.to raise_error(Jekyll::GitHubMetadata::Client::BadCredentialsError)
    end
  end

  context "render the 'uninject' fixture test site" do
    let(:source) { File.expand_path("test-site-uninject", __dir__) }
    let(:dest) { File.expand_path("../tmp/test-site-uninject-build", __dir__) }
    let(:config) { Jekyll::Configuration.from({ "source" => source, "destination" => dest }) }
    let(:fixture_rendered) { File.expand_path("test-site-uninject-rendered", __dir__) }

    it "process site twice (simulate reset), check API calls & rendered site" do
      site = Jekyll::Site.new(config)
      site.process
      # These API calls are expected because we use the attributes in the
      # fixture site.
      expect_api_call "/repos/jekyll/github-metadata"
      expect_api_call "/repos/jekyll/github-metadata/releases/latest"
      expect_api_call "/orgs/jekyll"
      site.process
      # After processing the site again, we expect that these API calls were
      # still only made once. We cache the results so we shouldn't be making the
      # same API call more than once.
      expect_api_call "/repos/jekyll/github-metadata"
      expect_api_call "/repos/jekyll/github-metadata/releases/latest"
      expect_api_call "/orgs/jekyll"

      # We do not expect these API calls to have been made since we do not use
      # these attributes in the fixture site.
      not_expect_api_call "/repos/jekyll/github-metadata/pages"
      not_expect_api_call "/repos/jekyll/github-metadata/contributors?per_page=100"
      not_expect_api_call "/orgs/jekyll/public_members?per_page=100"
      not_expect_api_call "/users/jekyll/repos?per_page=100&type=public"

      # Check to make sure the fixture site is rendered with the correct
      # site.github values.
      Dir.children(dest).each do |file|
        rendered_file = File.join(dest, file)
        fixture_file = File.join(fixture_rendered, file)
        expect(File.read(rendered_file)).to eql(File.read(fixture_file))
      end
    end
  end
end
