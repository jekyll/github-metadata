require 'jekyll'

module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      def generate(site)
        GitHubMetadata.repository = GitHubMetadata::Repository.new(site.config.fetch('repository'))
        site.config['github'] =
          case site.config['github']
          when nil
            GitHubMetadata.to_liquid
          when Hash
            Jekyll::Utils.deep_merge_hashes(GitHubMetadata.to_liquid, site.config['github'])
          else
            site.config['github']
          end
      end
    end
  end
end
