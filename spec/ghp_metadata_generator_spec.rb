require 'spec_helper'
require 'jekyll-github-metadata/ghp_metadata_generator'

RSpec.describe(Jekyll::GitHubMetadata::GHPMetadataGenerator) do
  let(:overrides) { {"repository" => "jekyll/another-repo"} }
  let(:config) { Jekyll::Configuration::DEFAULTS.merge(overrides) }
  let(:site) { Jekyll::Site.new config }
  subject { described_class.new(site.config) }

  context "with no repository set" do
    before(:each) do
      site.config.delete('repository')
      ENV['PAGES_REPO_NWO'] = nil
    end

    it "raises a NoRepositoryError" do
      expect(-> {
        subject.nwo(site)
      }).to raise_error(Jekyll::GitHubMetadata::NoRepositoryError)
    end
  end

  context "with PAGES_REPO_NWO and site.repository set" do
    before(:each) { ENV['PAGES_REPO_NWO'] = "jekyll/some-repo" }

    it "uses the value from PAGES_REPO_NWO" do
      expect(subject.nwo(site)).to eql("jekyll/some-repo")
    end
  end

  context "with only site.repository set" do
    before(:each) { ENV['PAGES_REPO_NWO'] = nil }

    it "uses the value from site.repository" do
      expect(subject.nwo(site)).to eql("jekyll/another-repo")
    end
  end
end
