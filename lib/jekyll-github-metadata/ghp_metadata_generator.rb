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
        end.uniq.first || ""
      end

      def nwo_from_git_origin_remote
        return unless Jekyll.env == "development"
        matches = git_remote_url.match %r{github.com(:|/)([\w-]+)/([\w-]+)}
        matches[2..3].join("/") if matches
      end

      def nwo_from_env
        ENV['PAGES_REPO_NWO']
      end

      def nwo_from_config(site)
        repo = site.config['repository']
        repo if repo && repo.is_a?(String) && repo.include?('/')
      end

      # Public: fetches the repository name with owner to fetch metadata for.
      # In order of precedence, this method uses:
      # 1. the environment variable $PAGES_REPO_NWO
      # 2. 'repository' variable in the site config
      # 3. the 'origin' git remote's URL
      #
      # site - the Jekyll::Site being processed
      #
      # Return the name with owner (e.g. 'parkr/my-repo') or raises an
      # error if one cannot be found.
      def nwo(site)
        nwo_from_env || \
          nwo_from_config(site) || \
          nwo_from_git_origin_remote || \
          proc {
            raise GitHubMetadata::NoRepositoryError, "No repo name found. " \
              "Specify using PAGES_REPO_NWO environment variables, " \
              "'repository' in your configuration, or set up an 'origin' " \
              "git remote pointing to your github.com repository."
          }.call
      end
    end
  end
end
