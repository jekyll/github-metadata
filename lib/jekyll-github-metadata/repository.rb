module Jekyll
  module GitHubMetadata
    class Repository
      attr_reader :nwo, :owner, :name
      def initialize(name_with_owner)
        @nwo   = name_with_owner
        @owner = nwo.split("/").first
        @name  = nwo.split("/").last
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

      def organization_repository?
        memoize_value :@is_organization_repository, Value.new(proc { |c| !!c.organization(owner) })
      end

      def owner_public_repositories
        memoize_value :@owner_public_repositories, Value.new(proc { |c| c.list_repos(owner, "type" => "public") })
      end

      def organization_public_members
        memoize_value :@organization_public_members, Value.new(proc { |c|
          c.organization_public_members(owner) if organization_repository?
        })
      end

      def contributors
        memoize_value :@contributors, Value.new(proc { |c| c.contributors(nwo) })
      end

      def releases
        memoize_value :@releases, Value.new(proc { |c| c.releases(nwo) })
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

      # In enterprise, the site's scheme will be the same as the instance's
      # In dotcom, this will be `https` for GitHub-owned sites that end with
      # `.github.com` and will be `http` for all other sites.
      # Note: This is not the same as *instance*'s scheme, which may differ
      def url_scheme
        if Pages.enterprise?
          Pages.scheme
        elsif owner == 'github' && domain.end_with?('.github.com')
          'https'
        else
          'http'
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
          "#{url_scheme}://#{domain}"
        else
          URI.join("#{url_scheme}://#{domain}", name).to_s
        end
      end

      def cname
        memoize_value :@cname, Value.new(proc { |c|
          if Pages.custom_domains_enabled?
            (c.pages(nwo) || {'cname' => nil})['cname']
          end
        })
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

      private

      def memoize_value(var_name, value)
        return instance_variable_get(var_name) if instance_variable_defined?(var_name)
        instance_variable_set(var_name, value.render)
      end
    end
  end
end
