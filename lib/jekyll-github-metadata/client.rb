module Jekyll
  module GitHubMetadata
    class Client
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
        options = options || Hash.new
        if ENV['JEKYLL_GITHUB_TOKEN'] || Octokit.access_token
          options.merge!(:access_token => ENV['JEKYLL_GITHUB_TOKEN'] || Octokit.access_token)
        elsif File.exist?(File.join(ENV['HOME'], '.netrc')) && safe_require('netrc')
          options.merge!(:netrc => true)
        else
          Jekyll.logger.warn "GitHubMetadata:", "No GitHub API authentication could be found." +
            " Some fields may be missing or have incorrect data."
        end
        Octokit::Client.new({:auto_paginate => false}.merge(options))
      end

      def method_missing(meth, *args, &block)
        if @client.respond_to?(meth)
          instance_variable_get(:"@#{meth}") ||
            instance_variable_set(:"@#{meth}", save_from_errors { @client.send(meth, *args, &block) })
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
  end
end
