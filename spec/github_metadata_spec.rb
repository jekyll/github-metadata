# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata) do
  let(:key_value_pair) { %w(some_key some_value) }

  it "has a global GitHub API client" do
    expect(described_class.client).to be_a(Jekyll::GitHubMetadata::Client)
  end

  it "does auto_paginate" do
    expect(
      described_class.client.instance_variable_get(:"@client").auto_paginate
    ).to be(true)
  end
end
