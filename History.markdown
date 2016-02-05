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
