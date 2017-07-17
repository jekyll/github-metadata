require "jekyll"
require "uri"

module Jekyll
  module GitHubMetadata
    class SiteGitHubMunger
      attr_reader :site

      def initialize(site)
        @site = site
      end

      def munge!
        Jekyll::GitHubMetadata.log :debug, "Initializing..."

        # This is the good stuff.
        site.config["github"] = github_namespace

        return unless should_add_fallbacks?
        add_url_and_baseurl_fallbacks!
        add_title_and_description_fallbacks!
      end

      private

      def github_namespace
        case site.config["github"]
        when nil
          drop
        when Hash
          Jekyll::Utils.deep_merge_hashes(site.config["github"], drop)
        else
          site.config["github"]
        end
      end

      def drop
        @drop ||= MetadataDrop.new(site)
      end

      # Set `site.url` and `site.baseurl` if unset.
      def add_url_and_baseurl_fallbacks!
        site.config["url"] ||= repository.url_without_path
        site.config["baseurl"] = repository.baseurl if should_set_baseurl?
      end

      # Set the baseurl only if it is `nil` or `/`
      # Baseurls should never be "/". See http://bit.ly/2s1Srid
      def should_set_baseurl?
        site.config["baseurl"].nil? || site.config["baseurl"] == "/"
      end

      def add_title_and_description_fallbacks!
        site.config["title"] ||= repository.name
        site.config["description"] ||= repository.tagline
      end

      def should_add_fallbacks?
        Jekyll.env == "production" || Pages.page_build?
      end

      def repository
        drop.send(:repository)
      end
    end
  end
end

Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::GitHubMetadata::SiteGitHubMunger.new(site).munge! unless Jekyll.env == "test"
end
