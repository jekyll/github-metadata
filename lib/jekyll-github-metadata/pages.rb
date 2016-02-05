module Jekyll
  module GitHubMetadata
    class Pages
      class << self
        DEFAULTS = {
          'PAGES_ENV'             => 'dotcom'.freeze,
          'PAGES_API_URL'         => 'https://api.github.com'.freeze,
          'PAGES_HELP_URL'        => 'https://help.github.com'.freeze,
          'PAGES_GITHUB_HOSTNAME' => 'https://github.com'.freeze,
          'PAGES_PAGES_HOSTNAME'  => 'github.io'.freeze,
          'SSL'                   => 'false'.freeze
        }.freeze

        def ssl?
          env_var('SSL').eql? 'true'
        end

        def scheme
          ssl? ? "https" : "http"
        end

        def env
          env_var 'PAGES_ENV'
        end

        def api_url
          trim_last_slash env_var('PAGES_API_URL', Octokit.api_endpoint)
        end

        def help_url
          trim_last_slash env_var('PAGES_HELP_URL')
        end

        def github_hostname
          trim_last_slash env_var('PAGES_GITHUB_HOSTNAME', Octokit.web_endpoint)
        end

        def pages_hostname
          trim_last_slash env_var('PAGES_PAGES_HOSTNAME')
        end

        private
        def env_var(key, intermediate_default = nil)
          !ENV[key].to_s.empty? ? ENV[key] : (intermediate_default || DEFAULTS[key])
        end

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
