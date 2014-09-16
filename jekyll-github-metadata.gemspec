# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-github-metadata/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-github-metadata"
  spec.version       = Jekyll::GitHubMetadata::VERSION
  spec.authors       = ["Parker Moore"]
  spec.email         = ["parkrmoore@gmail.com"]
  spec.summary       = %q{The site.github namespace}
  spec.homepage      = "https://github.com/jekyll/github-metadata"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").grep(%r{^(lib|bin)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octokit", "~> 3.3"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "jekyll", "~> 2.0"
end
