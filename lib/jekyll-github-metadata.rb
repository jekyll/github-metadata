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
    register_value('public_repositories', proc { |c,r| c.list_repos(r.owner, "type" => "public") })
    register_value('organization_members', proc { |c,r| c.organization_public_members(owner) if r.organization_repository? })
    register_value('build_revision', proc { `git rev-parse HEAD`.strip })
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
    register_value('url', 'http,//username.github.io/metadata-example') # (or the CNAME)
    #register_value('contributors', [ User Objects ])
  end
end

require_relative 'jekyll-github-metadata/ghp_metadata_generator'
