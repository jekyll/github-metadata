require 'octokit'
require_relative 'jekyll-github-metadata/version'

module Jekyll
  module GitHubMetadata
    class Value
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def render
        @value = @value.respond_to?(:call) ? @value.call(GitHubMetadata.client) : @value
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
        @client ||= Octokit::Client.new
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
