# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::Repository) do
  let(:repo) { described_class.new(nwo) }
  before(:each) do
    ENV["JEKYLL_GITHUB_TOKEN"] = "allthespecs"
  end

  context "with the html_url preview API turned on" do
    let(:nwo) { "jekyll/jekyll" }
    let!(:stub) do
      stub_api(
        "/repos/#{nwo}/pages",
        "jekyll_repo_pages",
        "Accept" => "application/vnd.github.mister-fantastic-preview+json"
      )
    end

    before(:each) { ENV["PAGES_PREVIEW_HTML_URL"] = "true" }
    after(:each) { ENV.delete("PAGES_PREVIEW_HTML_URL") }

    it "uses the html_url" do
      expect(repo.html_url).to eql("http://jekyllrb.com")
      expect(repo.repo_pages_info["html_url"]).to eql("#{repo.html_url}/")
    end

    it "sees the preview env" do
      expect(Jekyll::GitHubMetadata::Pages.repo_pages_html_url_preview?).to be_truthy
    end

    it "uses the preview accept header" do
      expect(repo.repo_pages_info_opts).to eql(
        :accept => "application/vnd.github.mister-fantastic-preview+json"
      )
    end

    it "respects the source branch" do
      expect(repo.git_ref).to eql("master")
    end
  end

  context "repository information" do
    let(:nwo) { "jekyll/jekyll" }
    let!(:stub) do
      stub_api(
        "/repos/#{nwo}/pages",
        "repo",
        "Accept" => "application/vnd.github.v3+json"
      )
    end

    it "returns the stargazers_count" do
      expect(repo.stargazers_count).to eq(22)
    end

    it "returns the fork count" do
      expect(repo.forks_count).to eq(4)
    end
  end

  context "hubot.github.com" do
    let(:nwo) { "github/hubot.github.com" }
    let!(:stub) { stub_api("/repos/#{nwo}/pages", "hubot_repo_pages") }

    it "forces HTTPS for the URL" do
      expect(repo.html_url).to eql("https://hubot.github.com")
    end

    it "returns the source" do
      expect(repo.source).to eql("branch" => "gh-pages", "path" => "docs/")
    end
  end

  context "ben.balter.com" do
    let(:nwo) { "benbalter/benbalter.github.com" }
    let!(:stub) { stub_api("/repos/#{nwo}/pages", "benbalter_repo_pages") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("ben.balter.com")
    end

    it "always returns HTTP for the scheme" do
      expect(repo.url_scheme).to eql("http")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.html_url).to eql("http://ben.balter.com")
    end

    it "parses the baseurl" do
      expect(repo.baseurl).to eql("")
    end

    it "returns the source" do
      expect(repo.source).to eql("branch" => "master", "path" => "/")
    end
  end

  context "parkr.github.io" do
    let(:nwo) { "parkr/parkr.github.io" }
    let!(:stub) { stub_api("/repos/#{nwo}/pages", "parkr_repo_pages") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("parkermoore.de")
    end

    it "returns Pages.scheme for the scheme" do
      expect(repo.url_scheme).to eql("http")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.html_url).to eql("http://parkermoore.de")
    end

    it "parses the baseurl" do
      expect(repo.baseurl).to eql("")
    end

    it "returns the source" do
      expect(repo.source).to eql("branch" => "master", "path" => "/")
    end
  end

  context "jldec.github.io" do
    let(:nwo) { "jldec/jldec.github.io" }
    let!(:stub) { stub_api("/repos/#{nwo}/pages", "jldec_repo_pages") }

    it "returns the CNAME as its domain" do
      expect(repo.domain).to eql("jldec.github.io")
    end

    it "always returns HTTP for the scheme" do
      expect(repo.url_scheme).to eql("https")
    end

    it "uses Pages.scheme to determine scheme for domain" do
      expect(repo.html_url).to eql("https://jldec.github.io")
    end

    it "parses the baseurl" do
      expect(repo.baseurl).to eql("")
    end

    it "returns the source" do
      expect(repo.source).to eql("branch" => "master", "path" => "/")
    end

    context "on enterprise" do
      let!(:stub) { stub_api("/repos/#{nwo}/pages", "jldec_enterprise_repo_pages") }

      it "uses Pages.scheme when SSL set to determine scheme for Pages URL" do
        # With SSL=true
        with_env(
          "PAGES_ENV"             => "enterprise",
          "SSL"                   => "true",
          "PAGES_GITHUB_HOSTNAME" => "github.acme.com"
        ) do
          expect(Jekyll::GitHubMetadata::Pages.ssl?).to be(true)
          expect(Jekyll::GitHubMetadata::Pages.scheme).to eql("https")
          expect(repo.html_url).to eql("https://github.acme.com/pages/#{nwo}")
          expect(repo.url_scheme).to eql("https")
          expect(repo.baseurl).to eql("/pages/#{nwo}")
        end
      end

      it "uses Pages.scheme when SSL not set to determine scheme for Pages URL" do
        with_env(
          "PAGES_ENV"             => "enterprise",
          "PAGES_GITHUB_HOSTNAME" => "github.acme.com"
        ) do
          expect(Jekyll::GitHubMetadata::Pages.ssl?).to be(false)
          expect(Jekyll::GitHubMetadata::Pages.scheme).to eql("http")
          expect(repo.html_url).to eql("http://github.acme.com/pages/#{nwo}")
          expect(repo.url_scheme).to eql("http")
        end
      end
    end

    context "in development" do
      let(:nwo) { "jekyll/jekyll" }

      it "github.com repo URL always https" do
        with_env(
          "GITHUB_HOSTNAME" => "github.com",
          "PAGES_ENV"       => "development"
        ) do
          expect(repo.repository_url).to eql("https://github.com/#{nwo}")
        end
      end

      it "non-github.com repo URL always http" do
        with_env(
          "GITHUB_HOSTNAME" => "xyz.example",
          "PAGES_ENV"       => "development"
        ) do
          expect(repo.repository_url).to eql("http://xyz.example/#{nwo}")
        end
      end
    end
  end
end
