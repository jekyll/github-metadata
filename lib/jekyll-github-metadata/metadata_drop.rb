require "jekyll"
require "forwardable"

module Jekyll
  module GitHubMetadata
    class MetadataDrop < Jekyll::Drops::Drop
      extend Forwardable

      mutable true

      def initialize(site)
        @site = site
        super(nil)
      end

      def to_s
        require "json"
        JSON.pretty_generate to_h
      end
      alias_method :to_str, :to_s

      def content_methods
        super - %w(to_s to_str)
      end

      def keys
        super.sort
      end

      def_delegator :"Jekyll::GitHubMetadata::Pages", :env, :environment
      def_delegator :"Jekyll::GitHubMetadata::Pages", :env, :pages_env
      def_delegator :"Jekyll::GitHubMetadata::Pages", :github_hostname, :hostname
      def_delegator :"Jekyll::GitHubMetadata::Pages", :pages_hostname, :pages_hostname
      def_delegator :"Jekyll::GitHubMetadata::Pages", :api_url, :api_url
      def_delegator :"Jekyll::GitHubMetadata::Pages", :help_url, :help_url

      def versions
        @versions ||= begin
          require "github-pages"
          GitHubPages.versions
        rescue LoadError
          {}
        end
      end

      def build_revision
        @build_revision ||= begin
          ENV["JEKYLL_BUILD_REVISION"] || `git rev-parse HEAD`.strip
        end
      end

      def_delegator :repository, :owner_public_repositories,   :public_repositories
      def_delegator :repository, :organization_public_members, :organization_members
      def_delegator :repository, :name,                        :project_title
      def_delegator :repository, :tagline,                     :project_tagline
      def_delegator :repository, :owner,                       :owner_name
      def_delegator :repository, :owner_url,                   :owner_url
      def_delegator :repository, :owner_gravatar_url,          :owner_gravatar_url
      def_delegator :repository, :repository_url,              :repository_url
      def_delegator :repository, :nwo,                         :repository_nwo
      def_delegator :repository, :name,                        :repository_name
      def_delegator :repository, :zip_url,                     :zip_url
      def_delegator :repository, :tar_url,                     :tar_url
      def_delegator :repository, :repo_clone_url,              :clone_url
      def_delegator :repository, :releases_url,                :releases_url
      def_delegator :repository, :issues_url,                  :issues_url
      def_delegator :repository, :wiki_url,                    :wiki_url
      def_delegator :repository, :language,                    :language
      def_delegator :repository, :user_page?,                  :is_user_page
      def_delegator :repository, :project_page?,               :is_project_page
      def_delegator :repository, :show_downloads?,             :show_downloads
      def_delegator :repository, :html_url,                    :url
      def_delegator :repository, :baseurl,                     :baseurl
      def_delegator :repository, :contributors,                :contributors
      def_delegator :repository, :releases,                    :releases
      def_delegator :repository, :latest_release,              :latest_release

      private
      attr_reader :site

      def repository
        @repository ||= GitHubMetadata::Repository.new(nwo(site)).tap do |repo|
          Jekyll::GitHubMetadata.log :debug, "Generating for #{repo.nwo}"
        end
      end

      def git_exe_path
        ENV["PATH"].to_s.split(File::PATH_SEPARATOR).map { |path| File.join(path, "git") }.find { |path| File.exist?(path) }
      end

      def git_remotes
        return [] if git_exe_path.nil?
        `#{git_exe_path} remote --verbose`.to_s.strip.split("\n")
      end

      def git_remote_url
        git_remotes.grep(%r!\Aorigin\t!).map do |remote|
          remote.sub(%r!\Aorigin\t(.*) \([a-z]+\)!, "\\1")
        end.uniq.first || ""
      end

      def nwo_from_git_origin_remote
        return unless Jekyll.env == "development" || Jekyll.env == "test"
        matches = git_remote_url.chomp(".git").match %r!github.com(:|/)([\w-]+)/([\w\.-]+)!
        matches[2..3].join("/") if matches
      end

      def nwo_from_env
        ENV["PAGES_REPO_NWO"]
      end

      def nwo_from_config(site)
        repo = site.config["repository"]
        repo if repo && repo.is_a?(String) && repo.include?("/")
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
          proc do
            raise GitHubMetadata::NoRepositoryError, "No repo name found. " \
              "Specify using PAGES_REPO_NWO environment variables, " \
              "'repository' in your configuration, or set up an 'origin' " \
              "git remote pointing to your github.com repository."
          end.call
      end

      # Nothing to see here.
      def fallback_data
        @fallback_data ||= {}
      end
    end
  end
end
