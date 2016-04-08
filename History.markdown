## HEAD

  * make empty string fallback for missing git remote (#54)
  * Refactor some of the git things & better docs (#55)

## 1.10.0 / 2016-03-25

  * Use git remote url to determine nwo (#45)

## 1.9.0 / 2016-03-16

  * Mark the generator as safe so in safe mode it'll work (#42)

## 1.8.0 / 2016-03-09

  * Properly determine project page domain by breaking the cache on different args (#40)

## 1.7.0 / 2016-03-02

  * Properly calculate the url scheme (#37)

## 1.6.0 / 2016-03-02

  * `site.github.environment` should be the same as `site.github.pages_env` (#36)
  * Add `Repository#url_scheme` for the pages URL scheme. (#35)

## 1.5.0 / 2016-02-29

  * All values should have a corresponding field on `Repository` (#34)
  * Happy Leap Day!

## 1.4.0 / 2016-02-19

  * Client: whitelist certain `Octokit::Client` methods (#32)

## 1.3.0 / 2016-02-12

  * Don't require Jekyll, and only require the Generator when Jekyll has been required
  * Client: Fix bug with method call memoization collision with special characters
  * Generator: Properly memoize the repository so each regen doesn't re-call
  * Pages: `ssl?` should be `true` in test mode
  * Pages: `github_hostname` should only include the domain, not the protocol
  * Pages: handle subdomain isolation
  * Pages: helper methods for `dotcom?`, `test?`, `enterprise?`
  * Pages: hardcode https for dotcom GitHub URL
  * Pages: api_url, help_url, github_hostname, and pages_hostname should all look at env vars without `PAGES_` prefix
  * Repository: `#organization_repository?` should use `Value` to save from errors
  * Repository: add in enterprise support & smarter CNAME/domain lookup

## 1.2.0 / 2016-02-05

  * Bring up-to-date with current `site.github` offerings on GitHub Pages (#30)
  * Add integration tests and ensure we're up-and-running with github-pages (#29)
  * Travis: test against Jekyll 2.5 and 3 (#21)

## 1.1.0 / 2015-09-07

  * Enable `auto_paginate` for Octokit client so you get everything (#18)

## v1.0.0 / 2015-06-02

  * Add `site.github.releases`, an array of your repo's releases. (#9)
  * Don't overwrite `site.github` if it's already set. Merge if it's a hash and just leave along if it's non-nil something else. (#15)
  * Fall back to Octokit values to be more compatible with the GitHub ecosystem (#10)
  * Fix bug where nil, true, false, and hashes were stringified by JSON (#11)
  * Add test site to as an integration test (#11)
  * Upgrade to Octokit v4.x (#10)

## v0.1.0 / 2014-09-19

  * Birthday!
