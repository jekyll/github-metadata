require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::MetadataDrop) do
  let(:overrides) { { "repository" => "jekyll/another-repo" } }
  let(:config) { Jekyll::Configuration.from(overrides) }
  let(:site) { Jekyll::Site.new config }
  subject { described_class.new(site) }
  before { Jekyll::GitHubMetadata.site = site }
  before { stub_all_api_requests }

  context "in Liquid" do
    before(:each) do
      site.config.delete("repository")
      site.config["github"] = subject
    end

    it "renders as a pretty JSON object in Liquid" do
      require "json"
      payload = site.site_payload
      expect(payload["site"]["github"]).to be_instance_of(described_class)
      expect(
        Liquid::Template.parse("{{ site.github }}").render!(
          payload, :registers => { :site => site }
        )
      ).to eql(JSON.pretty_generate(subject.to_h))
    end
  end

  context "payload" do
    let!(:payload) { subject.to_h }

    expected_values.each do |key, value|
      it "contains the #{key} key" do
        expect(payload).to have_key(key)
      end

      it "contains the correct value for #{key}" do
        if value.is_a? Regexp
          expect(payload[key].to_s).to match value
        else
          expect(payload[key]).to eql value
        end
      end
    end

    # Test to ensure we're testing all the values in the drop payload
    # If this test fails, you likely need to update a value in spec_helper.rb
    it "validates all values" do
      expect(payload.keys).to match_array(expected_values.keys)
    end
  end
end
