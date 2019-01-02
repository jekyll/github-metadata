# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::RepositoryCompat) do
  let(:repo) { Jekyll::GitHubMetadata::Repository.new(nwo) }
  let(:repo_compat) { repo.repo_compat }

  context "hubot.github.com" do
    let(:nwo) { "github/hubot.github.com" }
    before(:each) { allow(repo).to receive(:cname).and_return("hubot.github.com") }

    it "returns the CNAME as its domain" do
      expect(repo_compat.domain).to eql("hubot.github.com")
    end

    it "always returns HTTP for the scheme" do
      expect(repo_compat.url_scheme).to eql("https")
    end

    it "forces HTTPS for the URL" do
      expect(repo_compat.pages_url).to eql("https://hubot.github.com")
    end

    it "returns the source" do
      expect(repo_compat.source).to eql("branch" => "gh-pages", "path" => "/")
    end
  end

  context "ben.balter.com" do
    let(:nwo) { "benbalter/benbalter.github.com" }
    before(:each) { allow(repo).to receive(:cname).and_return("ben.balter.com") }

    it "returns the CNAME as its domain" do
      expect(repo_compat.domain).to eql("ben.balter.com")
    end

    it "always returns HTTP for the scheme" do
      expect(repo_compat.url_scheme).to eql("http")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo_compat.pages_url).to eql("http://ben.balter.com")
    end

    it "returns the source" do
      expect(repo_compat.source).to eql("branch" => "master", "path" => "/")
    end
  end

  context "parkr.github.io" do
    let(:nwo) { "parkr/parkr.github.io" }
    before(:each) { allow(repo).to receive(:cname).and_return(nil) }

    it "returns the CNAME as its domain" do
      expect(repo_compat.domain).to eql("parkr.github.io")
    end

    it "returns Pages.scheme for the scheme" do
      expect(repo_compat.url_scheme).to eql("http")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo_compat.pages_url).to eql("http://parkr.github.io")
    end

    it "returns the source" do
      expect(repo_compat.source).to eql("branch" => "master", "path" => "/")
    end

    context "on enterprise" do
      it "uses Pages.scheme to determine scheme for pages URL" do
        # With SSL=true
        with_env(
          "PAGES_ENV" => "enterprise",
          "SSL"       => "true"
        ) do
          expect(Jekyll::GitHubMetadata::Pages.ssl?).to be(true)
          expect(Jekyll::GitHubMetadata::Pages.scheme).to eql("https")
          expect(repo_compat.url_scheme).to eql("https")
        end

        # With no SSL
        with_env(
          "PAGES_ENV" => "enterprise"
        ) do
          expect(Jekyll::GitHubMetadata::Pages.ssl?).to be(false)
          expect(Jekyll::GitHubMetadata::Pages.scheme).to eql("http")
          expect(repo_compat.url_scheme).to eql("http")
        end
      end
    end
  end
end
