require 'jekyll'

module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      def generate(site)
        Jekyll.logger.debug "Generator:", "Calling GHPMetadataGenerator"
        GitHubMetadata.repository = GitHubMetadata::Repository.new(nwo(site))
        GitHubMetadata.init!
        Jekyll.logger.debug "GHMetadataGenerator:", "Generating for #{GitHubMetadata.repository.nwo}"
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

      def nwo(site)
        ENV['PAGES_REPO_NWO'] || \
          site.config['repository'] || \
          proc {
            raise GitHubMetadata::NoRepositoryError, "No repo name found. "
              "Specify using PAGES_REPO_NWO or 'repository' in your configuration."
          }.call
      end
    end
  end
end
