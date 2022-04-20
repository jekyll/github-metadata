# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::Client) do
  let(:token) { "abc1234" }
  subject { described_class.new(:access_token => token) }

  it "whitelists certain api calls" do
    described_class::API_CALLS.each do |method_name|
      expect(subject).to respond_to(method_name.to_sym)
    end
  end

  it "raises an error if an Octokit::Client method is called that's not whitelisted" do
    expect do
      subject.combined_status("jekyll/github-metadata", "refs/master")
    end.to raise_error(described_class::InvalidMethodError, "combined_status is not whitelisted on #<Jekyll::GitHubMetadata::Client @client=#<Octokit::Client (authenticated)> @internet_connected=true>")
  end

  it "can check if it's authenticated" do
    expect(subject.authenticated?).to be(true)
    expect(described_class.new(:access_token => nil).authenticated?).to be(false)
    expect(described_class.new(:access_token => "").authenticated?).to be(false)
  end

  it "raises an error for any api call with bad credentials" do
    stub_request(:get, url("/repos/jekyll/github-metadata/contributors?per_page=100"))
      .with(:headers => request_headers.merge(
        "Authorization" => "token #{token}"
      ))
      .to_return(
        :status  => 401,
        :headers => WebMockHelper::RESPONSE_HEADERS,
        :body    => webmock_data("bad_credentials")
      )
    expect do
      subject.contributors("jekyll/github-metadata")
    end.to raise_error(described_class::BadCredentialsError)
  end
end
