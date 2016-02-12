## 1.3.0 / 2015-02-12

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

## 1.2.0 / 2015-02-05

  * Bring up-to-date with current `site.github` offerings on GitHub Pages (#30)
  * Add integration tests and ensure we're up-and-running with github-pages (#29)
  * Travis: test against Jekyll 2.5 and 3 (#21)

## 1.1.0 / 2015-09-07

  * Enable `auto_paginate` for Octokit client so you get everything (#18)

## v1.0.0 / 2015-06-02

  * Add `site.github.releases`, an array of your repo's releases. (#9)
  * Don't overwrite `site.github` if it's already set. Merge if it's a hash
    and just leave along if it's non-nil something else. (#15)
  * Fall back to Octokit values to be more compatible with the GitHub ecosystem (#10)
  * Fix bug where nil, true, false, and hashes were stringified by JSON (#11)
  * Add test site to as an integration test (#11)
  * Upgrade to Octokit v4.x (#10)

## v0.1.0 / 2014-09-19

  * Birthday!
