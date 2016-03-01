require 'spec_helper'

RSpec.describe(Jekyll::GitHubMetadata::Repository) do
  let(:repo) { described_class.new(nwo) }

  context "hubot.github.com" do
    let(:nwo) { "github/hubot.github.com" }
    before(:each) { allow(repo).to receive(:cname).and_return("hubot.github.com") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("hubot.github.com")
    end

    it "forces HTTPS for the URL" do
      expect(repo.pages_url).to eql("https://hubot.github.com")
    end
  end

  context "benbalter.github.com" do
    let(:nwo) { "benbalter/benbalter.github.com" }
    before(:each) { allow(repo).to receive(:cname).and_return("ben.balter.com") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("ben.balter.com")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.pages_url).to eql("http://ben.balter.com")
    end
  end
end
