# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::Pages) do
  context "enterprise" do
    before(:each) { ENV["PAGES_ENV"] = "enterprise" }
    after(:each)  { ENV["PAGES_ENV"] = "test" }

    let(:ghe_domain) { "ghe.io" }

    it "disables custom domains" do
      expect(described_class.custom_domains_enabled?).to be false
    end

    it "looks for the domain specified" do
      with_env("GITHUB_HOSTNAME", ghe_domain) do
        expect(described_class.github_url).to eql("http://#{ghe_domain}")
        expect(described_class.github_hostname).to eql ghe_domain
      end
    end

    it "handles a separate pages hostname" do
      pages_hostname = "pages.#{ghe_domain}"
      with_env("PAGES_HOSTNAME", pages_hostname) do
        expect(described_class.pages_hostname).to eql pages_hostname
      end
    end
  end

  context ".configuration" do
    it "returns the entire configuration" do
      expect(described_class.configuration).to eql(
        "api_url"                      => "https://api.github.com",
        "custom_domains_enabled?"      => true,
        "development?"                 => false,
        "dotcom?"                      => false,
        "enterprise?"                  => false,
        "env"                          => "test",
        "github_hostname"              => "github.com",
        "github_url"                   => "https://github.com",
        "help_url"                     => "https://docs.github.com",
        "page_build?"                  => false,
        "pages_hostname"               => "github.io",
        "repo_pages_html_url_preview?" => nil,
        "scheme"                       => "https",
        "ssl?"                         => true,
        "subdomain_isolation?"         => false,
        "test?"                        => true
      )
    end
  end

  context ".env" do
    it "picks up on PAGES_ENV" do
      with_env("PAGES_ENV", "halp") do
        expect(described_class.env).to eql("halp")
      end
    end

    it "picks up on JEKYLL_ENV" do
      with_env "PAGES_ENV", "" do
        with_env "JEKYLL_ENV", "halp" do
          expect(described_class.env).to eql("halp")
        end
      end
    end

    it "has convenience methods for various envs" do
      with_env("PAGES_ENV", "test") do
        expect(described_class.test?).to be true
        expect(described_class.dotcom?).to be false
        expect(described_class.enterprise?).to be false
        expect(described_class.development?).to be false
      end
      with_env("PAGES_ENV", "dotcom") do
        expect(described_class.test?).to be false
        expect(described_class.dotcom?).to be true
        expect(described_class.enterprise?).to be false
        expect(described_class.development?).to be false
      end
      with_env("PAGES_ENV", "enterprise") do
        expect(described_class.test?).to be false
        expect(described_class.dotcom?).to be false
        expect(described_class.enterprise?).to be true
        expect(described_class.development?).to be false
      end
      with_env("PAGES_ENV", "development") do
        expect(described_class.test?).to be false
        expect(described_class.dotcom?).to be false
        expect(described_class.enterprise?).to be false
        expect(described_class.development?).to be true
      end
    end
  end

  context ".ssl?" do
    before(:each) { ENV["PAGES_ENV"] = "dotcom" }
    after(:each)  { ENV["PAGES_ENV"] = "test" }

    it "only returns true when $SSL is set to 'true'" do
      with_env "SSL", "true" do
        expect(described_class.ssl?).to be true
      end
      with_env "SSL", "trueish" do
        expect(described_class.ssl?).to be false
      end
    end

    it "is true in PAGES_ENV=test" do
      with_env(
        "PAGES_ENV" => "test",
        "SSL"       => "false"
      ) do
        expect(described_class.ssl?).to be true
      end
    end
  end

  context ".subdomain_isolation?" do
    it "returns true when $SUBDOMAIN_ISOLATION is set to 'true'" do
      with_env "SUBDOMAIN_ISOLATION", "true" do
        expect(described_class.subdomain_isolation?).to be true
      end
    end

    it "returns false for any other value" do
      with_env "SUBDOMAIN_ISOLATION", "" do
        expect(described_class.subdomain_isolation?).to be false
      end
    end
  end

  context "development" do
    it "uses the local pages hostname" do
      with_env "PAGES_ENV", "development" do
        expect(described_class.pages_hostname).to eql("localhost:4000")
      end
    end
  end

  context ".page_build?" do
    it "returns true when $PAGE_BUILD_ID is set" do
      with_env "PAGE_BUILD_ID", "123" do
        expect(described_class.page_build?).to be(true)
      end
    end

    it "returns false by default" do
      expect(described_class.page_build?).to be(false)
    end
  end
end
