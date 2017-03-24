require "jekyll"
require "uri"

module Jekyll
  module GitHubMetadata
    module SiteGitHubMunger
      extend self

      def already_generated?(site)
        @already_generated ||= {}
        @already_generated.key?(site.object_id)
      end

      def munge(site)
        return if already_generated?(site)

        Jekyll::GitHubMetadata.log :debug, "Initializing..."

        # This is the good stuff.
        site.config["github"] = github_namespace(site)
        set_url_and_baseurl_fallbacks(site)

        mark_already_generated(site)
      end

      private

      def mark_already_generated(site)
        @already_generated ||= {}
        @already_generated[site.object_id] = true
      end

      def github_namespace(site)
        case site.config["github"]
        when nil
          drop(site)
        when Hash, Liquid::Drop
          Jekyll::Utils.deep_merge_hashes(drop(site), site.config["github"])
        else
          site.config["github"]
        end
      end

      def drop(site)
        @drop_cache ||= {}
        @drop_cache[site.object_id] ||= MetadataDrop.new(site)
      end

      # Set `site.url` and `site.baseurl` if unset.
      def set_url_and_baseurl_fallbacks(site)
        return unless Jekyll.env == "production" || Pages.page_build?

        repo = drop(site).send(:repository)
        site.config["url"] ||= repo.url_without_path
        if site.config["baseurl"].to_s.empty? && !["", "/"].include?(repo.baseurl)
          site.config["baseurl"] = repo.baseurl
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :after_reset do |site|
  Jekyll::GitHubMetadata::SiteGitHubMunger.munge(site)
end
