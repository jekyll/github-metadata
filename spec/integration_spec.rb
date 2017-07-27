require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/site_github_munger"

RSpec.describe("integration into a jekyll site") do
  SOURCE_DIR = Pathname.new(File.expand_path("../test-site", __FILE__))
  DEST_DIR = Pathname.new(File.expand_path("../../tmp/test-site-build", __FILE__))

  def dest_dir(*files)
    DEST_DIR.join(*files)
  end

  let!(:stubs) { stub_all_api_requests }

  before(:each) do
    # Run Jekyll
    ENV.delete("JEKYLL_ENV")
    ENV["PAGES_ENV"] = "dotcom"
    Jekyll.logger.log_level = :error
    Jekyll::Commands::Build.process({
      "source"      => SOURCE_DIR.to_s,
      "destination" => DEST_DIR.to_s,
      "gems"        => %w(jekyll-github-metadata),
      "plugins"     => %w(jekyll-github-metadata),
    })
  end
  after(:each) do
    ENV.delete("PAGES_ENV")
    ENV["JEKYLL_ENV"] = "test"
  end
  subject { SafeYAML.load(dest_dir("rendered.txt").read) }

  expected_values.each do |key, value|
    it "contains the correct #{key}" do
      expect(subject).to have_key(key)
      if value.is_a? Regexp
        expect(subject[key].to_s).to match value
      else
        expect(subject[key]).to eql value
      end
    end
  end

  it "calls all the stubs" do
    stubs.each do |stub|
      expect(stub).to have_been_requested
    end
  end
end
