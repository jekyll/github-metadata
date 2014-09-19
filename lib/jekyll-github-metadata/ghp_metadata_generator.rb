require 'jekyll'

module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      def generate(site)
        GitHubMetadata.repository = GitHubMetadata::Repository.new(site.config.fetch('repository'))
        site.config['github'] = GitHubMetadata.to_liquid
      end
    end
  end
end