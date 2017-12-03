# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::MetadataDrop) do
  extend IntegrationHelper

  let(:overrides) { { "repository" => "jekyll/another-repo" } }
  let(:config) { Jekyll::Configuration.from(overrides) }
  let(:site) { Jekyll::Site.new config }
  subject { described_class.new(site) }
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

  context "returning values" do
    context "native methods" do
      it "returns a value via #[]" do
        expect(subject["url"]).to eql("http://jekyll.github.io/github-metadata")
      end

      it "returns a value via #invoke_drop" do
        expect(subject.invoke_drop("url")).to eql("http://jekyll.github.io/github-metadata")
      end

      it "responds to #key?" do
        expect(subject.key?("url")).to be_truthy
      end
    end

    context "with mutated values" do
      before { subject["url"] = "foo" }

      it "returns the mutated value via #[]" do
        expect(subject["url"]).to eql("foo")
      end

      it "returns the mutated  via #invoke_drop" do
        expect(subject.invoke_drop("url")).to eql("foo")
      end

      it "responds to #key?" do
        expect(subject.key?("url")).to be_truthy
      end
    end

    context "with fallback data" do
      let(:fallback_data) { { "foo" => "bar" } }
      before { subject.instance_variable_set("@fallback_data", fallback_data) }

      it "returns the mutated value via #[]" do
        expect(subject["foo"]).to eql("bar")
      end

      it "returns the mutated  via #invoke_drop" do
        expect(subject.invoke_drop("foo")).to eql("bar")
      end

      it "responds to #key?" do
        expect(subject.key?("foo")).to be_truthy
      end
    end
  end
end
