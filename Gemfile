# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "faraday", "~> #{ENV["FARADAY_VERSION"]}" if ENV["FARADAY_VERSION"]
gem "jekyll", "~> #{ENV["JEKYLL_VERSION"]}" if ENV["JEKYLL_VERSION"]

group :test do
  # Temporarily lock rspec dependencies to last known versions with
  # which tests passed successfully on CI
  gem "rspec-expectations", "3.8.4"
  gem "rspec-mocks", "3.8.1"

  gem "webmock", "~> 2.0"
end
