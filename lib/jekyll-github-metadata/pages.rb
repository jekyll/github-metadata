module Jekyll
  module GitHubMetadata
    class Pages
      class << self
        def env
          ENV.fetch('PAGES_ENV', 'dotcom')
        end

        def api_url
          trim_last_slash(ENV['PAGES_API_URL'] || Octokit.api_endpoint || 'https://api.github.com')
        end

        def github_hostname
          trim_last_slash(ENV['PAGES_GITHUB_HOSTNAME'] || Octokit.web_endpoint || 'https://github.com')
        end

        def pages_hostname
          trim_last_slash(ENV.fetch('PAGES_PAGES_HOSTNAME', 'github.io'))
        end

        private
        def trim_last_slash(url)
          if url[-1] == "/"
            url[0..-2]
          else
            url
          end
        end
      end
    end
  end
end
