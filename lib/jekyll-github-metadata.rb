require 'octokit'
require_relative 'jekyll-github-metadata/version'

module Jekyll
  module GitHubMetadata
    class Client
      def initialize(options = nil)
        require 'octokit'
        @client = build_octokit_client(options)
      end

      def safe_require(gem_name)
        require gem_name
        true
      rescue LoadError
        false
      end

      def build_octokit_client(options = Hash.new)
        if ENV['JEKYLL_GITHUB_TOKEN']
          Octokit::Client.new(options.merge!(:access_token => ENV['JEKYLL_GITHUB_TOKEN']))
        elsif File.exist?(File.join(ENV['HOME'], '.netrc')) && safe_require('netrc')
          Octokit::Client.new(options.merge!(:netrc => true))
        end
        Octokit::Client.new(options)
      end

      def method_missing(meth, *args, &block)
        if @client.respond_to?(meth)
          save_from_errors { @client.send(meth, *args, &block) }
        else
          super(meth, *args, &block)
        end
      end

      def save_from_errors(default = false, &block)
        if block.arity == 1
          block.call(@client)
        else
          block.call
        end
      rescue Faraday::Error::ConnectionFailed,
        Octokit::NotFound,
        Octokit::Unauthorized,
        Octokit::TooManyRequests
        default
      end
    end

    class Value
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def render
        @value = if @value.respond_to?(:call)
          if @value.arity == 1
            @value.call(GitHubMetadata.client)
          else
            @value.call
          end
        else
          @value
        end
      end

      def to_s
        render.to_s
      end

      def to_liquid
        render
      end
    end

    class Pages
      class << self
        def env
          ENV.fetch('PAGES_ENV', 'dotcom')
        end

        def api_url
          'https://api.github.com'
        end

        def github_hostname
          'github.com'
        end

        def pages_hostname
          'github.io'
        end
      end
    end

    class << self
      def environment
        Jekyll.env || Pages.env || 'development'
      end

      def client
        @client ||= Client.new
      end

      def values
        @values ||= Hash.new
      end

      def clear_values!
        @values = Hash.new
      end

      def [](key)
        values[key.to_s]
      end

      def to_h
        values
      end

      def to_liquid
        to_h
      end

      def register_value(key, value)
        values[key.to_s] = Value.new(value)
      end
    end

    # Environment-Specific
    register_value('environment', proc { environment })
    register_value('hostname', proc { Pages.github_hostname })
    register_value('pages_hostname', proc { Pages.pages_hostname })
    register_value('api_url', proc { Pages.api_url })

    register_value('versions', proc {
      begin
        require 'github-pages'
        GitHubPages.versions
      rescue LoadError; Hash.new end
    })

    # The Juicy Stuff
    register_value('public_repositories', proc { |c| c. })
    register_value('organization_members', [ User Objects ])
    register_value('build_revision', 'cbd866ebf142088896cbe71422b949de7f864bce')
    register_value('project_title', 'metadata-example')
    register_value('project_tagline', 'A GitHub Pages site to showcase repository metadata')
    register_value('owner_name', 'github')
    register_value('owner_url', 'https,//github.com/github')
    register_value('owner_gravatar_url', 'https,//github.com/github.png')
    register_value('repository_url', 'https,//github.com/github/metadata-example')
    register_value('repository_nwo', 'github/metadata-example')
    register_value('repository_name', 'metadata-example')
    register_value('zip_url', 'https,//github.com/github/metadata-example/zipball/gh-pages')
    register_value('tar_url', 'https,//github.com/github/metadata-example/tarball/gh-pages')
    register_value('clone_url', 'https,//github.com/github/metadata-example.git')
    register_value('releases_url', 'https,//github.com/github/metadata-example/releases')
    register_value('issues_url', 'https,//github.com/github/metadata-example/issues')
    register_value('wiki_url', 'https,//github.com/github/metadata-example/wiki')
    register_value('language', nil)
    register_value('is_user_page', false)
    register_value('is_project_page', true)
    register_value('show_downloads', true)
    register_value('url', 'http,//username.github.io/metadata-example', // (or the CNAME)
    register_value('contributors', [ User Objects )
  end
end
