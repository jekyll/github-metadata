# frozen_string_literal: true

source "https://rubygems.org"
gemspec

# rubocop:disable Bundler/DuplicatedGem
if ENV["JEKYLL_VERSION"]
  gem "jekyll", "~> #{ENV["JEKYLL_VERSION"]}"
elsif ENV["JEKYLL_HEAD"]
  gem "jekyll", :git => "https://github.com/jekyll/jekyll.git", :branch => "master"
end
# rubocop:enable Bundler/DuplicatedGem

group :test do
  gem "webmock", "~> 2.0"
end
