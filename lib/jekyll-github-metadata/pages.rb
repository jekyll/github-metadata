module Jekyll
  module GitHubMetadata
    class Pages
      class << self
        def env
          ENV.fetch('PAGES_ENV', 'dotcom')
        end

        def api_url
          'https://api.github.com'
        end

        def github_url
          'github.com'
        end

        def pages_hostname
          'github.io'
        end
      end
    end
  end
end
