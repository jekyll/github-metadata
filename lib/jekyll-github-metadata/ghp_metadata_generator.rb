require "jekyll"
require "uri"

module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      safe true

      attr_reader :site

      def generate(site)
        if defined?(@_already_generated)
          Jekyll::GitHubMetadata.log :debug, "Nothing left to do!"
          return
        end

        Jekyll::GitHubMetadata.log :debug, "Initializing..."
        @site = site
        site.config["github"] = github_namespace
        set_url_and_baseurl_fallbacks!
        @site = nil
        @_already_generated = true # don't do this again.
      end

      private

      def github_namespace
        case site.config["github"]
        when nil
          drop
        when Hash, Liquid::Drop
          Jekyll::Utils.deep_merge_hashes(drop, site.config["github"])
        else
          site.config["github"]
        end
      end

      def drop
        @drop ||= MetadataDrop.new(site)
      end

      # Set `site.url` and `site.baseurl` if unset.
      def set_url_and_baseurl_fallbacks!
        return unless Jekyll.env == "production" || Pages.page_build?

        repo = drop.send(:repository)
        site.config["url"] ||= repo.url_without_path
        if site.config["baseurl"].to_s.empty? && !["", "/"].include?(repo.baseurl)
          site.config["baseurl"] = repo.baseurl
        end
      end
    end
  end
end
