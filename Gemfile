# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "faraday", "~> #{ENV["FARADAY_VERSION"]}" if ENV["FARADAY_VERSION"]
gem "jekyll", "~> #{ENV["JEKYLL_VERSION"]}" if ENV["JEKYLL_VERSION"]

group :test do
  gem "webmock", "~> 2.0"
end
