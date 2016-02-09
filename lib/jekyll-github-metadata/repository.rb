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
        !!Value.new(proc { |c| c.organization(owner) }).render
      end

      def git_ref
        user_page? ? 'master' : 'gh-pages'
      end

      def repo_info
        @repo_info ||= (Value.new(proc { |c| c.repository(nwo) }).render || Hash.new)
      end

      def language
        repo_info["language"]
      end

      def tagline
        repo_info["description"]
      end

      def owner_url
        "#{Pages.github_url}/#{owner}"
      end

      def owner_gravatar_url
        "#{owner_url}.png"
      end

      def repo_clone_url
        "#{repository_url}.git"
      end

      def repository_url
        "#{owner_url}/#{name}"
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
        !user_page?
      end

      def github_repo?
        !Pages.enterprise? && owner.eql?('github')
      end

      def primary?
        if Pages.enterprise?
          name.downcase == "#{owner.to_s.downcase}.#{Pages.github_hostname}"
        else
          user_page_domains.include? name.downcase
        end
      end

      def default_user_domain
        if github_repo?
          "#{owner}.#{Pages.github_hostname}".downcase
        elsif Pages.enterprise?
          Pages.pages_hostname.downcase
        else
          "#{owner}.#{Pages.pages_hostname}".downcase
        end
      end

      def user_page_domains
        domains = [default_user_domain]
        domains.push "#{owner}.github.com".downcase unless Pages.enterprise?
        domains
      end

      def user_domain
        domain = default_user_domain
        user_page_domains.each do |user_repo|
          candidate_nwo = "#{owner}/#{user_repo}"
          next unless Value.new(proc { |client| client.repository? candidate_nwo }).render
          domain = self.class.new(candidate_nwo).domain
        end
        domain
      end

      def pages_url
        if !Pages.custom_domains_enabled?
          path = user_page? ? owner : nwo
          if Pages.subdomain_isolation?
            URI.join("#{Pages.scheme}://#{Pages.pages_hostname}/", path).to_s
          else
            URI.join("#{Pages.github_url}/pages/", path).to_s
          end
        elsif cname || primary?
          "#{Pages.scheme}://#{domain}"
        else
          URI.join("#{Pages.scheme}://#{domain}", name).to_s
        end
      end

      def cname
        return unless Pages.custom_domains_enabled?
        @cname ||= (Value.new('cname', proc { |c| c.pages(nwo) }).render || {'cname' => nil})['cname']
      end

      def domain
        @domain ||=
          if !Pages.custom_domains_enabled?
            Pages.github_hostname
          elsif cname # explicit CNAME
            cname
          elsif primary? # user/org repo
            default_user_domain
          else # project repo
            user_domain
          end
      end
    end
  end
end
