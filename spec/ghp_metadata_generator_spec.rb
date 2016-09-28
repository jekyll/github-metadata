require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/ghp_metadata_generator"

RSpec.describe(Jekyll::GitHubMetadata::GHPMetadataGenerator) do
  subject { described_class.new }
  let(:source) { File.expand_path("../test-site", __FILE__) }
  let(:dest) { File.expand_path("../../tmp/test-site-build", __FILE__)}
  let(:user_config) { {} }
  let(:configuration) do
    merged_config = user_config.merge({source: source, dest: dest, quiet: true})
    Jekyll.configuration(merged_config)
  end
  let(:site) { Jekyll::Site.new(configuration) }

  it "is safe" do
    expect(described_class.safe).to be(true)
  end

  context "generating" do
    before { stub_api("/repos/jekyll/github-metadata" , "repo") }
    before { stub_api("/repos/jekyll/github-metadata/pages" , "repo_pages") }
    before { stub_api("/repos/jekyll/jekyll.github.io" , "repo") }
    before { stub_api("/repos/jekyll/jekyll.github.io/pages" , "repo_pages") }
    before { stub_api("/repos/jekyll/jekyll.github.com" , "repo") }
    before { stub_api("/repos/jekyll/jekyll.github.com/pages" , "repo_pages") }

    before do
      ENV["NO_NETRC"] = "true"
      ENV["JEKYLL_GITHUB_TOKEN"] = "1234abc"
      ENV["PAGES_REPO_NWO"] = "jekyll/github-metadata"
      ENV["PAGES_ENV"] = "dotcom"
    end
    before(:each) { site.process }

    context "with site.url set" do
      let(:user_config) { { url: "http://example.com" } }

      it "doesn't mangle site.url" do
        expect(site.config["url"]).to eql("http://example.com")
      end
    end

    context "with site.baseurl set" do
      let(:user_config) { { baseurl: "/foo" } }

      it "doesn't mangle site.url" do
        expect(site.config["baseurl"]).to eql("/foo")
      end
    end

    context "without site.url set" do
      it "sets site.url" do
        expect(site.config["url"]).to eql("http://example.com")
      end
    end

    context "without site.baseurl set" do
      it "sets site.baseurl" do
        expect(site.config["baseurl"]).to eql("/foo")
      end
    end
  end
end
