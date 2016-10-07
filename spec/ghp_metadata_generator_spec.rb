require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/ghp_metadata_generator"

RSpec.describe(Jekyll::GitHubMetadata::GHPMetadataGenerator) do
  subject { described_class.new }
  let(:source) { File.expand_path("../test-site", __FILE__) }
  let(:dest) { File.expand_path("../../tmp/test-site-build", __FILE__) }
  let(:user_config) { {} }
  let(:site) { Jekyll::Site.new(Jekyll::Configuration.from(user_config)) }

  it "is safe" do
    expect(described_class.safe).to be(true)
  end

  context "generating" do
    let!(:stubs) { stub_all_api_requests }
    before(:each) do
      ENV["JEKYLL_ENV"] = "production"
      subject.generate(site)
    end
    after(:each) do
      ENV.delete("JEKYLL_ENV")
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
  end
end
