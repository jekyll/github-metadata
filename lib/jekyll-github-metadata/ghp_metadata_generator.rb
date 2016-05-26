require 'jekyll'

module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      safe true

      def generate(site)
        Jekyll::GitHubMetadata.log :debug, "Initializing..."

        drop = MetadataDrop.new(site)
        site.config['github'] =
          case site.config['github']
          when nil
            MetadataDrop.new(site)
          when Hash, Liquid::Drop
            Jekyll::Utils.deep_merge_hashes(MetadataDrop.new(site), site.config['github'])
          else
            site.config['github']
          end
      end
    end
  end
end
