module Jekyll
  module GitHubMetadata
    class Repository
      attr_reader :nwo, :owner, :name
      def initialize(name_with_owner)
        @nwo   = name_with_owner
        @owner = nwo.split("/").first
        @name  = nwo.split("/").last
      end

      def organization_repository?
        !!GitHubMetadata.client.organization(owner)
      end

      def git_ref
        user_page? ? 'master' : 'gh-pages'
      end

      def repo_info
        @repo_into ||= (Value.new(proc { |c| c.repository(nwo) }).render || Hash.new)
      end

      def language
        repo_info["language"]
      end

      def tagline
        repo_info["description"]
      end

      def owner_url
        "https://#{Pages.github_url}/#{owner}"
      end

      def owner_gravatar_url
        "#{owner_url}.png"
      end

      def repo_clone_url
        "#{repository_url}.git"
      end

      def repository_url
        "https://#{Pages.github_url}/#{nwo}"
      end

      def zip_url
        "#{repository_url}/zipball/#{git_ref}"
      end

      def tar_url
        "#{repository_url}/tarball/#{git_ref}"
      end

      def releases_url
        "#{repository_url}/releases"
      end

      def issues_url
        "#{repository_url}/issues" if repo_info["has_issues"]
      end

      def wiki_url
        "#{repository_url}/wiki" if repo_info["has_wiki"]
      end

      def show_downloads?
        !!repo_info["has_downloads"]
      end

      def user_page?
        primary?
      end

      def project_page?
        !primary?
      end

      def primary?
        user_page_domains.include? name.downcase
      end

      def github_repo?
        owner.eql?('github')
      end

      def default_user_domain
        if github_repo?
          "#{owner}.#{Pages.github_hostname}".downcase
        else
          "#{owner}.#{Pages.pages_hostname}".downcase
        end
      end

      def user_page_domains
        [
          default_user_domain,
          "#{owner}.github.com".downcase # legacy
        ]
      end

      def pages_url
        if cname || primary?
          "http://#{domain}"
        else
          File.join("http://#{domain}", name)
        end
      end

      def cname
        @cname ||= (Value.new(proc { |c| c.pages(nwo) }).render || {'cname' => nil})['cname']
      end

      def domain
        cname || default_user_domain
      end
    end
  end
end
