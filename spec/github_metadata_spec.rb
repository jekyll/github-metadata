require 'spec_helper'

RSpec.describe(Jekyll::GitHubMetadata) do
  let(:key_value_pair) { %w{some_key some_value} }
  before(:each) do
    described_class.clear_values!
  end

  it 'allows you to register values' do
    expect(described_class.register_value(*key_value_pair)).not_to be_nil
  end

  it 'knows how to turn into Liquid' do
    expect(described_class).to respond_to(:to_liquid)
    expect(described_class.to_liquid).to be_a(Hash)
  end

  it 'has a hash representation' do
    expect(described_class).to respond_to(:to_h)
    expect(described_class.to_h).to be_a(Hash)
  end

  it 'stores the key-value pairs in a values hash' do
    described_class.register_value(*key_value_pair)
    expect(described_class['some_key'].to_s).to eql('some_value')
  end

  it 'has a global GitHub API client' do
    expect(described_class.client).to be_a(Jekyll::GitHubMetadata::Client)
  end
end
