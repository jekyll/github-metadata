# frozen_string_literal: true

require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/site_github_munger"

RSpec.describe("integration into a jekyll site") do
  extend IntegrationHelper

  let!(:stubs) { stub_all_api_requests }

  before(:each) do
    # Run Jekyll
    ENV.delete("JEKYLL_ENV")
    ENV["JEKYLL_ENV"] = "production"
    ENV["PAGES_ENV"] = "dotcom"
    Jekyll.logger.log_level = :error
    Jekyll::Commands::Build.process(config_defaults)
  end
  after(:each) do
    ENV.delete("PAGES_ENV")
    ENV["JEKYLL_ENV"] = "test"
  end
  subject { SafeYAML.load(in_dest_dir("rendered.txt").read) }

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

  it "contains the correct public_repositories.releases" do
    expect(subject).to have_key("public_repositories")
    expect(subject["public_repositories"].first).to have_key("releases")
    expect(subject["public_repositories"].first["releases"].size).to eql(3)
    expect(subject["public_repositories"].first["releases"].first["name"]).to eql("v1.1.0")
    expect(subject["public_repositories"].first["releases"].first["target_commitish"]).to eql("master")
  end

  it "contains the correct public_repositories.contributors" do
    expect(subject).to have_key("public_repositories")
    expect(subject["public_repositories"].first).to have_key("contributors")
    expect(subject["public_repositories"].first["contributors"].size).to eql(1)
    expect(subject["public_repositories"].first["contributors"].first["login"]).to eql("parkr")
  end

  it "calls all the stubs" do
    stubs.each do |stub|
      expect(stub).to have_been_requested
    end
  end

  it "presents the owner data as a Hash" do
    expect(subject["owner"]).to be_a(Hash)
  end
end
