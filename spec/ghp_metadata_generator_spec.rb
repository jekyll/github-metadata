require "spec_helper"
require "jekyll"
require "jekyll-github-metadata/ghp_metadata_generator"

RSpec.describe(Jekyll::GitHubMetadata::GHPMetadataGenerator) do
  subject { described_class.new }

  it "is safe" do
    expect(described_class.safe).to be(true)
  end
end
