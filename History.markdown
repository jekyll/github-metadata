## HEAD

### Development Fixes

  * Restore log level after running tests that modify it. (#202)
  * Add GitHub Actions CI (#211)

### Minor Enhancements

  * Use owner name as site title for User and Organization sites. (#197)

### Documentation

  * docs: Add dev docs (#212)

## 2.13.0 / 2020-01-15

### Minor Enhancements

  * Lessen Jekyll dependency (#164)
  * Enable support for `topics` property (#166)
  * Allow detecting archived or disabled repos (#176)

### Bug Fixes

  * Conditionally memoize certain private methods in EditLinkTag (#163)
  * Fix faraday connectionfailed issue (#178)
  * MetadataDrop: don't use instance variable to check mutations (#173)

### Documentation Fixes

  * List the fields this repo generates for `site.github` (#171)
  * Use HTML entities to prevent Liquid from processing this documentation (#172)

## 2.12.1 / 2019-02-11

### Bug Fixes

  * Add `Owner#to_liquid` (#161)

## 2.12.0 / 2019-02-11

### Bug Fixes

  * `site.owner` should be a `Hash` in the final value (#160)

## 2.11.0 / 2019-01-29

### Minor Enhancements

  * Expose User/Org information under `site.github.owner` (#151)
  * Add new attributes to return for users and repositories (#158)
  * Move `owner_metadata` to an Owner class and add specs (#159)

### Development Fixes

  * Fix specs to be compatible with forked repositories (#152)
  * Update CI settings and use rubocop-jekyll (#150)

## 2.10.0 / 2019-01-02

### Minor Enhancements

  * Allow detecting repository on GitHub Enterprise (#147)
  * Remove redundant code (#140)
  * Constant accessors for `def_delegation` (#141)

### Bug Fixes

  * Fixes for repository detection on Windows (#136)
  * Make github.com repo URLs always https (#133)

### Documentation

  * Add instructions for using DotEnv (#92)

### Development Fixes

  * Test against Ruby 2.5 (#119)
  * Add script/console to help debug (#124)

## 2.9.4 / 2017-12-08

### Minor Enhancements

  * Warn and do nothing when site.name is set (#113)

### Documentation

  * Docs: use plugins config key (#115)

## 2.9.3 / 2017-09-07

  * Mutable drops should fallback to their own methods when a mutation isn't present #112

## 2.9.2 / 2017-09-07

### Minor Enhancements

  * Allow user values to override drop-determined values (#110)

## 2.9.1 / 2017-08-28

  * Fix for "undefined method `path` for Hash" error

## 2.9.0 / 2017-08-28

  * GitHub edit link tag (#108)
  * Define path with __dir__ (#109)

## 2.8.0 / 2017-08-15

### Minor Enhancements

  * Expose site source (#107)

## 2.7.0 / 2017-08-14

### Minor Enhancements

  * Expose repo license (#106)

## 2.6.0 / 2017-08-08

### Minor Enhancements

  * Set title and description in dev (#104)
  * Detect whether the client is connected to the internet. Only allow client calls if connected. (#90)
  * Expose repo visibility (#105)

## 2.5.0 / 2017-07-17

  * Set default `site.title` and `site.description` (#101)
  * Modernize Travis configuration (#102)
  * Allow user to set empty `baseurl` (#97)
  * add `latest_release` and `latest_release_url` (#88)
  * Make the Octokit client more configurable. (#84)

## 2.4.0 / 2017-03-30

### Minor Enhancements

  * Don't double-process the site.github namespace. (#95)
  * Add .configuration and .page_build? methods to Pages (#89)

## 2.3.1 / 2017-01-18

  * Remove log on Octokit::NotFound (#86)

## 2.3.0 / 2017-01-09

### Minor Enhancements

  * Respect source passed from the API (#85)

## 2.2.0 / 2016-10-25

### Minor Enhancements

  * If a user provides bad credentials, throw an error. (#75)

### Bug Fixes

  * Add `MetadataDrop#to_s` which outputs pretty JSON representation (#78)
  * Lock Octokit to v4.3.0 (#79)
  * Revert "Lock Octokit to v4.3.0", but disallow v4.4.0 (#81)

## 2.1.1 / 2016-10-07

### Bug Fixes

  * Remove the `path` before setting `site.url` (#77)

## 2.1.0 / 2016-10-05

### Major Enhancements

  * Set site.url and site.baseurl (#76)
  * Use `localhost:4000` as the default pages host in development (#50)
  * Default to development in dev (#49)

### Minor Enhancements

  * Fix a typo in the documentation of `PAGES_API_URL` (#66)
  * Additional feedback for failed Octokit calls (#68)
  * Add Rubocop (#69)

## 2.0.2 / 2016-06-22

  * Remove trailing slash from html_url if present (#64)

## 2.0.1 / 2016-06-19

  * Fix issue where `git` not being in `$PATH` would error (#57)
  * Handle dots in repository names when parsing from Git remote output (#63)

## 2.0.0 / 2016-05-26

### Major Enhancements

  * Only allow Jekyll 3.1 and above (#61)

### Minor Enhancements

  * Use html_url from Pages endpoint (behind preview env flag) (#60)
  * Only determine repo when data is requested using a Drop (#61)

## 1.11.1 / 2016-04-22

  * Make the `Client::API_CALLS` a Set (#56)

## 1.11.0 / 2016-04-08

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
