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

    class << self
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
  end
end

Jekyll::GitHubMetadata.register_value('environment', proc { |c|
  ENV.fetch('JEKYLL_ENV', ENV.fetch('PAGES_ENV', 'development'))
})
