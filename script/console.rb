# frozen_string_literal: true

require "octokit"
require "pry"

stack = Faraday::RackBuilder.new do |builder|
  builder.use Octokit::Middleware::FollowRedirects
  builder.use Octokit::Response::RaiseError
  builder.use Octokit::Response::FeedParser
  builder.response :logger
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

require_relative "../lib/jekyll-github-metadata"

binding.pry
