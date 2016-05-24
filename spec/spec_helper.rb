require 'jekyll-github-metadata'
require 'webmock/rspec'
require 'pathname'

SPEC_DIR = Pathname.new(File.expand_path("../", __FILE__))

module WebMockHelper
  REQUEST_HEADERS = {
    'Accept'          => 'application/vnd.github.v3+json',
    'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Content-Type'    => 'application/json',
    'User-Agent'      => "Octokit Ruby Gem #{Octokit::VERSION}"
  }.freeze
  RESPONSE_HEADERS = {
    'Transfer-Encoding'   => 'chunked',
    'Content-Type'        => 'application/json; charset=utf-8',
    'Vary'                => 'Accept-Encoding',
    'Content-Encoding'    => 'gzip',
    'X-GitHub-Media-Type' => 'github.v3; format=json'
  }.freeze

  def stub_api(path, filename)
    WebMock.disable_net_connect!
    stub_request(:get, url(path)).
      with(:headers => request_headers).
      to_return(
        :status  => 200,
        :headers => RESPONSE_HEADERS,
        :body    => webmock_data(filename)
      )
  end

  def expect_api_call(path)
    expect(WebMock).to have_requested(:get, url(path)).
      with(:headers => request_headers).once
  end

  def request_headers
    REQUEST_HEADERS.merge({
      'Authorization' => "token #{ENV.fetch("JEKYLL_GITHUB_TOKEN", "1234abc")}"
    })
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

module EnvHelper
  def with_env(*args)
    env_hash = env_args_to_hash(*args)
	old_env = {}
	env_hash.each do |name, value|
	  old_env[name] = ENV[name]
	  ENV[name] = value
	end
	yield
  ensure
	old_env.each do |name, value|
	  ENV[name] = value
	end
  end

  private
  def env_args_to_hash(*args)
    case args.length
    when 2
      env_hash = {}
      env_hash[args.first] = args.last
      return env_hash
    when 1
      return args.first if args.first.is_a? Hash
    end
    raise ArgumentError, "Expect 2 strings or a Hash of VAR => VAL"
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  # For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = false

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  # config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.include WebMockHelper
  WebMock.disable_net_connect!
  config.include EnvHelper

  config.before(:each) { Jekyll::GitHubMetadata.init! }
end
