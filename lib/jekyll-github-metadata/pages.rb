module Jekyll
  module GitHubMetadata
    class Pages
      class << self
        def env
          ENV.fetch('PAGES_ENV', 'dotcom')
        end

        def api_url
          ENV['PAGES_API_URL'] || Octokit.api_endpoint || 'https://api.github.com'
        end

        def github_hostname
          ENV['PAGES_GITHUB_HOSTNAME'] || Octokit.web_endpoint || 'https://github.com'
        end

        def pages_hostname
          ENV.fetch('PAGES_PAGES_HOSTNAME', 'github.io')
        end
      end
    end
  end
end
