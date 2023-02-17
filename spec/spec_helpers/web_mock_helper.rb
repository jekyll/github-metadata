# frozen_string_literal: true

module WebMockHelper
  REQUEST_HEADERS = {
    "Accept"          => %r!application/vnd\.github\.(v3|drax-preview|mercy-preview)\+json!,
    "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
    "Content-Type"    => "application/json",
    "User-Agent"      => "Octokit Ruby Gem #{Octokit::VERSION}",
  }.freeze
  RESPONSE_HEADERS = {
    "Transfer-Encoding"   => "chunked",
    "Content-Type"        => "application/json; charset=utf-8",
    "Vary"                => "Accept-Encoding",
    "Content-Encoding"    => "gzip",
    "X-GitHub-Media-Type" => "github.v3; format=json",
  }.freeze

  def stub_api(path, filename, req_headers = {})
    WebMock.disable_net_connect!
    stub_request(:get, url(path))
      .with(:headers => request_headers.merge(req_headers))
      .to_return(
        :status  => 200,
        :headers => RESPONSE_HEADERS,
        :body    => webmock_data(filename)
      )
  end

  def stub_api_404(path, req_headers = {})
    WebMock.disable_net_connect!
    stub_request(:get, url(path))
      .with(:headers => request_headers.merge(req_headers))
      .to_return(
        :status  => 404,
        :headers => RESPONSE_HEADERS
      )
  end

  def expect_api_call(path)
    expect(WebMock).to have_requested(:get, url(path))
      .with(:headers => request_headers).once
  end

  def not_expect_api_call(path)
    expect(WebMock).to have_requested(:get, url(path))
      .with(:headers => request_headers).times(0)
  end

  def request_headers
    REQUEST_HEADERS.merge(
      "Authorization" => "token #{ENV.fetch("JEKYLL_GITHUB_TOKEN", "1234abc")}"
    )
  end

  private

  def url(path)
    "#{Jekyll::GitHubMetadata::Pages.api_url}#{path}"
  end

  def webmock_data(filename)
    @webmock_data ||= {}
    @webmock_data[filename] ||= SPEC_DIR.join("webmock/api_get_#{filename}.json").read
  end
end
