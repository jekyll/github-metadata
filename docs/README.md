# GitHub Metadata, a.k.a. `site.github`

[![Linux Build Status](https://img.shields.io/travis/jekyll/github-metadata/master.svg?label=Linux%20build)][travis]
[![Windows Build status](https://img.shields.io/appveyor/ci/jekyll/github-metadata/master.svg?label=Windows%20build)][appveyor]

[travis]: https://travis-ci.org/jekyll/github-metadata
[appveyor]: https://ci.appveyor.com/project/jekyll/github-metadata


Jekyll plugin to propagate the `site.github` namespace and set default values for use with GitHub Pages.

## What it does

* Propagates the `site.github` namespace with [repository metadata](site.github.md)
* Sets `site.title` as the repository name, if none is set
* Sets `site.description` as the repository tagline if none is set
* Sets `site.url` as the GitHub Pages domain (cname or user domain), if none is set
* Sets `site.baseurl` as the project name for project pages if none is set

## Usage

Usage of this gem is pretty straight-forward. Add it to your `Gemfile` like this:

```ruby
gem "jekyll-github-metadata"
```

Add it to your `_config.yml`:

```yaml
plugins:
  - "jekyll-github-metadata"
```

:warning: If you are using Jekyll < 3.5.0, use the `gems` key instead of `plugins`.

Then go ahead and run `bundle install`.

Now, whenever you build or serve with Jekyll, the `jekyll-github-metadata` plugin will run.


## Further reading

* [Authentication](authentication.md)
* [Configuration](configuration.md)
* [Using `site.github`](site.github.md)
* [Edit on GitHub link](edit-on-github-link.md)
* [Development](development.md)
