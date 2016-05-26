require 'spec_helper'

RSpec.describe(Jekyll::GitHubMetadata::MetadataDrop) do
  let(:overrides) { {"repository" => "jekyll/another-repo"} }
  let(:config) { Jekyll::Configuration::DEFAULTS.merge(overrides) }
  let(:site) { Jekyll::Site.new config }
  subject { described_class.new(site) }

  context "with no repository set" do
    before(:each) do
      site.config.delete('repository')
      ENV['PAGES_REPO_NWO'] = nil
    end

    context "without a git nwo" do
      it "raises a NoRepositoryError" do
        allow(subject).to receive(:git_remote_url).and_return("")
        expect(-> {
          subject.send(:nwo, site)
        }).to raise_error(Jekyll::GitHubMetadata::NoRepositoryError)
      end
    end

    it "retrieves the git remote" do
      allow(subject).to receive(:git_remote_url).and_call_original
      expect(subject.send(:git_remote_url)).to include("jekyll/github-metadata")
    end

    {
      https: "https://github.com/foo/bar",
      ssh:   "git@github.com:foo/bar.git"
    }.each do |type, url|
      context "with a #{type} git URL" do
        it "parses the name with owner from the git URL" do
          allow(subject).to receive(:git_remote_url).and_return(url)
          expect(subject.send(:nwo, site)).to eql("foo/bar")
        end
      end
    end
  end

  context "with PAGES_REPO_NWO and site.repository set" do
    before(:each) { ENV['PAGES_REPO_NWO'] = "jekyll/some-repo" }

    it "uses the value from PAGES_REPO_NWO" do
      expect(subject.send(:nwo, site)).to eql("jekyll/some-repo")
    end
  end

  context "with only site.repository set" do
    before(:each) { ENV['PAGES_REPO_NWO'] = nil }

    it "uses the value from site.repository" do
      expect(subject.send(:nwo, site)).to eql("jekyll/another-repo")
    end
  end
end
