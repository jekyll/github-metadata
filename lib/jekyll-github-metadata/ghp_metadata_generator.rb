module Jekyll
  module GitHubMetadata
    class GHPMetadataGenerator < Jekyll::Generator
      safe true

      def generate(site)
        Jekyll.logger.debug "Generator:", "Calling GHPMetadataGenerator"
        initialize_repo! nwo(site)
        Jekyll.logger.debug "GitHub Metadata:", "Generating for #{GitHubMetadata.repository.nwo}"

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

      private

      def initialize_repo!(repo_nwo)
        if GitHubMetadata.repository.nil? || GitHubMetadata.repository.nwo != repo_nwo
          GitHubMetadata.init!
          GitHubMetadata.repository = GitHubMetadata::Repository.new(repo_nwo)
        end
      end

      def git_remote_url
        `git remote --verbose`.split("\n").grep(%r{\Aorigin\t}).map do |remote|
          remote.sub(/\Aorigin\t(.*) \([a-z]+\)/, "\\1")
        end.uniq.first
      end

      def git_nwo
        return unless Jekyll.env == "development"
        matches = git_remote_url.match %r{github.com(:|/)([\w-]+)/([\w-]+)}
        matches[2..3].join("/") if matches
      end

      def nwo(site)
        ENV['PAGES_REPO_NWO'] || \
          site.config['repository'] || \
          git_nwo || \
          proc {
            raise GitHubMetadata::NoRepositoryError, "No repo name found. "
              "Specify using PAGES_REPO_NWO or 'repository' in your configuration."
          }.call
      end
    end
  end
end
