require 'spec_helper'

RSpec.describe(Jekyll::GitHubMetadata::Repository) do
  let(:repo) { described_class.new(nwo) }
  before(:each) do
    ENV['JEKYLL_GITHUB_TOKEN'] = "allthespecs"
    Jekyll::GitHubMetadata.reset!
    stub.stub = stub_api(stub.path, stub.file)
  end

  context "hubot.github.com" do
    let(:nwo)  { "github/hubot.github.com" }
    let(:stub) { ApiStub.new("/repos/#{nwo}/pages", "hubot_repo_pages") }

    it "forces HTTPS for the URL" do
      expect(repo.pages_url).to eql("https://hubot.github.com")
    end
  end

  context "ben.balter.com" do
    let(:nwo) { "benbalter/benbalter.github.com" }
    let(:stub) { ApiStub.new("/repos/#{nwo}/pages", "benbalter_repo_pages") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("ben.balter.com")
    end

    it "always returns HTTP for the scheme" do
      expect(repo.url_scheme).to eql("http")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.pages_url).to eql("http://ben.balter.com")
    end
  end

  context "parkr.github.io" do
    let(:nwo) { "parkr/parkr.github.io" }
    let(:stub) { ApiStub.new("/repos/#{nwo}/pages", "parkr_repo_pages") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("parkermoore.de")
    end

    it "returns Pages.scheme for the scheme" do
      expect(repo.url_scheme).to eql("http")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.pages_url).to eql("http://parkermoore.de")
    end
  end

  context "jldec.github.io" do
    let(:nwo) { "jldec/jldec.github.io" }
    let(:stub) { ApiStub.new("/repos/#{nwo}/pages", "jldec_repo_pages") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("jldec.github.io")
    end

    it "always returns HTTP for the scheme" do
      expect(repo.url_scheme).to eql("https")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.pages_url).to eql("https://jldec.github.io")
    end

    context "on enterprise" do
      let(:stub) { ApiStub.new("/repos/#{nwo}/pages", "jldec_enterprise_repo_pages") }

      it "uses Pages.scheme to determine scheme for pages URL" do
        # With SSL=true
        with_env({
          "PAGES_ENV"             => "enterprise",
          "SSL"                   => "true",
          "PAGES_GITHUB_HOSTNAME" => "github.acme.com"
        }) do
          expect(Jekyll::GitHubMetadata::Pages.ssl?).to be(true)
          expect(Jekyll::GitHubMetadata::Pages.scheme).to eql("https")
          expect(repo.pages_url).to eql("https://github.acme.com/pages/#{nwo}")
          expect(repo.url_scheme).to eql("https")
        end

        # With no SSL
        with_env({
          "PAGES_ENV" => "enterprise",
          "PAGES_PAGES_HOSTNAME" => "pages.acme.com"
        }) do
          expect(Jekyll::GitHubMetadata::Pages.ssl?).to be(false)
          expect(Jekyll::GitHubMetadata::Pages.scheme).to eql("http")
          expect(repo.pages_url).to eql("https://enterprise.github.com/#{nwo}/pages")
          expect(repo.url_scheme).to eql("http")
        end
      end
    end
  end
end
