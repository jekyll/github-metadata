module Jekyll
  module GitHubMetadata
    class Pages
      class << self
        def env
          ENV.fetch('PAGES_ENV', 'dotcom')
        end

        def api_url
          ENV.fetch('PAGES_API_URL', 'https://api.github.com')
        end

        def github_hostname
          ENV.fetch('PAGES_GITHUB_HOSTNAME', 'github.com')
        end

        def pages_hostname
          ENV.fetch('PAGES_PAGES_HOSTNAME', 'github.io')
        end
      end
    end
  end
end
