# frozen_string_literal: true

module FixtureHelper
  def in_dest_dir(*files)
    dest_dir.join(*files)
  end

  def dest_dir
    @dest_dir ||= Pathname.new(File.expand_path("../../tmp/test-site-build", __dir__))
  end

  def source_dir
    @source_dir ||= Pathname.new(File.expand_path("../test-site", __dir__))
  end

  def config_defaults
    {
      "source"      => source_dir.to_s,
      "destination" => dest_dir.to_s,
      "plugins"     => ["jekyll-github-metadata"],
      "gems"        => ["jekyll-github-metadata"],
    }
  end

  def make_page(data = {}, pager = nil)
    data["paginated"] = true unless pager.nil?
    Jekyll::Page.new(site, config_defaults["source"], "", "page.md").tap do |page| 
      page.data = data
      page.pager = pager
    end
  end

  def make_pager(page)
    Pager.new(page)
  end

  def make_site(options = {})
    config = Jekyll.configuration config_defaults.merge(options)
    Jekyll::Site.new(config)
  end

  def make_context(registers = {}, environments = {})
    context = { :site => make_site, :page => make_page }.merge(registers)
    Liquid::Context.new(environments, {}, context)
  end

  class Pager
    attr_accessor :page

    def initialize(page)
      @page = page
    end
  end
end
