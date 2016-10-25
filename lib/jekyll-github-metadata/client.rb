require "digest"

module Jekyll
  module GitHubMetadata
    class Client
      InvalidMethodError = Class.new(NoMethodError)
      BadCredentialsError = Class.new(StandardError)

      # Whitelisted API calls.
      API_CALLS = Set.new(%w(
        repository
        organization
        repository?
        pages
        contributors
        releases
        list_repos
        organization_public_members
      ))

      def initialize(options = nil)
        @client = build_octokit_client(options)
      end

      def safe_require(gem_name)
        require gem_name
        true
      rescue LoadError
        false
      end

      def build_octokit_client(options = nil)
        options ||= {}
        unless options.key? :access_token
          options.merge! pluck_auth_method
        end
        Octokit::Client.new({ :auto_paginate => true }.merge(options))
      end

      def accepts_client_method?(method_name)
        API_CALLS.include?(method_name.to_s) && @client.respond_to?(method_name)
      end

      def respond_to_missing?(method_name, include_private = false)
        accepts_client_method?(method_name) || super
      end

      def method_missing(method_name, *args, &block)
        method = method_name.to_s
        if accepts_client_method?(method_name)
          key = cache_key(method_name, args)
          Jekyll::GitHubMetadata.log :debug, "Calling @client.#{method}(#{args.map(&:inspect).join(", ")})"
          cache[key] ||= save_from_errors { @client.public_send(method_name, *args, &block) }
        elsif @client.respond_to?(method_name)
          raise InvalidMethodError, "#{method_name} is not whitelisted on #{inspect}"
        else
          super
        end
      end

      def save_from_errors(default = false)
        yield @client
      rescue Octokit::Unauthorized
        raise BadCredentialsError, "The GitHub API credentials you provided aren't valid."
      rescue Faraday::Error::ConnectionFailed, Octokit::TooManyRequests => e
        Jekyll::GitHubMetadata.log :warn, e.message
        default
      rescue Octokit::NotFound => e
        Jekyll::GitHubMetadata.log :error, e.message
        default
      end

      def inspect
        "#<#{self.class.name} @client=#{client_inspect}>"
      end

      def authenticated?
        !@client.access_token.to_s.empty?
      end

      private

      def client_inspect
        if @client.nil?
          "nil"
        else
          "#<#{@client.class.name} (#{"un" unless authenticated?}authenticated)>"
        end
      end

      def pluck_auth_method
        if ENV["JEKYLL_GITHUB_TOKEN"] || Octokit.access_token
          { :access_token => ENV["JEKYLL_GITHUB_TOKEN"] || Octokit.access_token }
        elsif !ENV["NO_NETRC"] && File.exist?(File.join(ENV["HOME"], ".netrc")) && safe_require("netrc")
          { :netrc => true }
        else
          Jekyll::GitHubMetadata.log :warn, "No GitHub API authentication could be found." \
            " Some fields may be missing or have incorrect data."
          {}.freeze
        end
      end

      def cache_key(method, *args)
        Digest::SHA1.hexdigest(method.to_s + args.join(", "))
      end

      def cache
        @cache ||= {}
      end
    end
  end
end
