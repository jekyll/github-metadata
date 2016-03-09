require 'octokit'

module Jekyll
  unless const_defined? :Errors
    module Errors
      FatalException = Class.new(::RuntimeError) unless const_defined? :FatalException
    end
  end

  module GitHubMetadata
    NoRepositoryError = Class.new(Jekyll::Errors::FatalException)

    autoload :Client,     'jekyll-github-metadata/client'
    autoload :Pages,      'jekyll-github-metadata/pages'
    autoload :Repository, 'jekyll-github-metadata/repository'
    autoload :Sanitizer,  'jekyll-github-metadata/sanitizer'
    autoload :Value,      'jekyll-github-metadata/value'
    autoload :VERSION,    'jekyll-github-metadata/version'

    class << self
      attr_accessor :repository
      attr_writer :client

      def environment
        Jekyll.respond_to?(:env) ? Jekyll.env : (Pages.env || 'development')
      end

      def client
        @client ||= Client.new
      end

      def values
        @values ||= Hash.new
      end
      alias_method :to_h, :values
      alias_method :to_liquid, :to_h

      def clear_values!
        @values = Hash.new
      end

      def reset!
        clear_values!
        @client = nil
        @repository = nil
      end

      def [](key)
        values[key.to_s]
      end

      def register_value(key, value)
        values[key.to_s] = Value.new(key.to_s, value)
      end

      # Reset our values hash.
      def init!
        clear_values!

        # Environment-Specific
        register_value('environment', proc { Pages.env })
        register_value('hostname', proc { Pages.github_hostname })
        register_value('pages_env', proc { Pages.env })
        register_value('pages_hostname', proc { Pages.pages_hostname })
        register_value('api_url', proc { Pages.api_url })
        register_value('help_url', proc { Pages.help_url })

        register_value('versions', proc {
          begin
            require 'github-pages'
            GitHubPages.versions
          rescue LoadError; Hash.new end
        })

        # The Juicy Stuff
        register_value('public_repositories',  proc { |_,r| r.owner_public_repositories })
        register_value('organization_members', proc { |_,r| r.organization_public_members })
        register_value('build_revision',       proc {
          ENV['JEKYLL_BUILD_REVISION'] || `git rev-parse HEAD`.strip
        })
        register_value('project_title',        proc { |_,r| r.name })
        register_value('project_tagline',      proc { |_,r| r.tagline })
        register_value('owner_name',           proc { |_,r| r.owner })
        register_value('owner_url',            proc { |_,r| r.owner_url })
        register_value('owner_gravatar_url',   proc { |_,r| r.owner_gravatar_url })
        register_value('repository_url',       proc { |_,r| r.repository_url })
        register_value('repository_nwo',       proc { |_,r| r.nwo })
        register_value('repository_name',      proc { |_,r| r.name})
        register_value('zip_url',              proc { |_,r| r.zip_url })
        register_value('tar_url',              proc { |_,r| r.tar_url })
        register_value('clone_url',            proc { |_,r| r.repo_clone_url })
        register_value('releases_url',         proc { |_,r| r.releases_url })
        register_value('issues_url',           proc { |_,r| r.issues_url })
        register_value('wiki_url',             proc { |_,r| r.wiki_url })
        register_value('language',             proc { |_,r| r.language })
        register_value('is_user_page',         proc { |_,r| r.user_page? })
        register_value('is_project_page',      proc { |_,r| r.project_page? })
        register_value('show_downloads',       proc { |_,r| r.show_downloads? })
        register_value('url',                  proc { |_,r| r.pages_url })
        register_value('contributors',         proc { |_,r| r.contributors })
        register_value('releases',             proc { |_,r| r.releases })

        values
      end

      if Jekyll.const_defined? :Site
        require_relative 'jekyll-github-metadata/ghp_metadata_generator'
      end
    end

    init!
  end
end
