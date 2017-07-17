require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/site_github_munger"

RSpec.describe(Jekyll::GitHubMetadata::SiteGitHubMunger) do
  let(:source) { File.expand_path("../test-site", __FILE__) }
  let(:dest) { File.expand_path("../../tmp/test-site-build", __FILE__) }
  let(:user_config) { {} }
  let(:site) { Jekyll::Site.new(Jekyll::Configuration.from(user_config)) }
  subject { described_class.new(site) }

  context "generating" do
    let!(:stubs) { stub_all_api_requests }
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      subject.munge!
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
  end

  context "with a client with no credentials" do
    before(:each) do
      Jekyll::GitHubMetadata.client = Jekyll::GitHubMetadata::Client.new({ :access_token => "" })
    end

    it "does not fail upon call to #munge" do
      expect(lambda do
        subject.munge!
      end).not_to raise_error
    end

    it "sets the site.github config" do
      subject.munge!
      expect(site.config["github"]).to be_instance_of(Jekyll::GitHubMetadata::MetadataDrop)
    end
  end

  context "with a client with bad credentials" do
    before(:each) do
      Jekyll::GitHubMetadata.client = Jekyll::GitHubMetadata::Client.new({ :access_token => "1234abc" })
      stub_request(:get, url("/repos/jekyll/github-metadata/pages"))
        .with(:headers => request_headers.merge({
          "Authorization" => "token 1234abc",
        }))
        .to_return(
          :status  => 401,
          :headers => WebMockHelper::RESPONSE_HEADERS,
          :body    => webmock_data("bad_credentials")
        )
    end

    it "fails loudly upon call to any drop method" do
      subject.munge!
      expect(lambda do
        site.config["github"]["url"]
      end).to raise_error(Jekyll::GitHubMetadata::Client::BadCredentialsError)
    end
  end
end
