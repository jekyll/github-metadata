require 'octokit'

module Jekyll
  module GitHubMetadata
    autoload :Client,     'jekyll-github-metadata/client'
    autoload :Pages,      'jekyll-github-metadata/pages'
    autoload :Repository, 'jekyll-github-metadata/repository'
    autoload :Sanitizer,  'jekyll-github-metadata/sanitizer'
    autoload :Value,      'jekyll-github-metadata/value'
    autoload :VERSION,    'jekyll-github-metadata/version'

    class << self
      attr_accessor :repository

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

      def reset!
        clear_values!
        @client = nil
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
        values[key.to_s] = Value.new(key.to_s, value)
      end

      # Reset our values hash.
      def init!
        reset!

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
        register_value('public_repositories',  proc { |c,r| c.list_repos(r.owner, "type" => "public") })
        register_value('organization_members', proc { |c,r| c.organization_public_members(r.owner) if r.organization_repository? })
        register_value('build_revision',       proc { `git rev-parse HEAD`.strip })
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
        register_value('contributors',         proc { |c,r| c.contributors(r.nwo) })
        register_value('releases',             proc { |c,r| c.releases(r.nwo) })
      end
    end

    init!
  end
end

require_relative 'jekyll-github-metadata/ghp_metadata_generator'
