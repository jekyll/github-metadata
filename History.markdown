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
