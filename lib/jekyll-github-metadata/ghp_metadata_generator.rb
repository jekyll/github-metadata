require "jekyll"

module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      safe true

      attr_reader :site

      def generate(site)
        Jekyll::GitHubMetadata.log :debug, "Initializing..."
        @site = site
        site.config["github"] = github_namespace

        # Set `site.url` and `site.baseurl` if unset and in production mode.
        if Jekyll.env == "production"
          site.config["url"] ||= drop.url
          site.config["baseurl"] = drop.baseurl if site.config["baseurl"].to_s.empty?
        end

        @site = nil
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
    end
  end
end
