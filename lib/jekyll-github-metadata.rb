require "octokit"
require "logger"

if defined?(Jekyll) && Jekyll.respond_to?(:env) && Jekyll.env == "development"
  begin
    require "dotenv"
    Dotenv.load
  rescue LoadError
    Jekyll.logger.debug "Dotenv not found. Skipping"
  end
end

module Jekyll
  unless const_defined? :Errors
    module Errors
      FatalException = Class.new(::RuntimeError) unless const_defined? :FatalException
    end
  end

  module GitHubMetadata
    NoRepositoryError = Class.new(Jekyll::Errors::FatalException)

    autoload :Client,           "jekyll-github-metadata/client"
    autoload :MetadataDrop,     "jekyll-github-metadata/metadata_drop"
    autoload :Pages,            "jekyll-github-metadata/pages"
    autoload :Repository,       "jekyll-github-metadata/repository"
    autoload :RepositoryCompat, "jekyll-github-metadata/repository_compat"
    autoload :Sanitizer,        "jekyll-github-metadata/sanitizer"
    autoload :Value,            "jekyll-github-metadata/value"
    autoload :VERSION,          "jekyll-github-metadata/version"

    if Jekyll.const_defined? :Site
      require_relative "jekyll-github-metadata/site_github_munger"
    end

    class << self
      attr_accessor :repository
      attr_writer :client, :logger

      def environment
        Jekyll.respond_to?(:env) ? Jekyll.env : (Pages.env || "development")
      end

      def logger
        @logger ||= if Jekyll.respond_to?(:logger)
                      Jekyll.logger
                    else
                      Logger.new($stdout)
                    end
      end

      def log(severity, message)
        if logger.method(severity).arity.abs >= 2
          logger.public_send(severity, "GitHub Metadata:", message.to_s)
        else
          logger.public_send(severity, "GitHub Metadata: #{message}")
        end
      end

      def client
        @client ||= Client.new
      end

      def reset!
        @logger = nil
        @client = nil
      end
    end
  end
end
