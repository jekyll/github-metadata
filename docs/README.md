# GitHub Metadata, a.k.a. `site.github`

[![Build Status](https://travis-ci.org/jekyll/github-metadata.svg?branch=test-site)](https://travis-ci.org/jekyll/github-metadata)

Jekyll plugin to propagate the `site.github` namespace and set default values for use with GitHub Pages.

## What it does

* Propagates the `site.github` namespace with [repository metadata](https://help.github.com/articles/repository-metadata-on-github-pages/)
* Sets `site.title` as the repository name, if none is set
* Sets `site.description` as the repository tagline if none is set
* Sets `site.url` as the GitHub Pages domain (cname or user domain), if none is set
* Sets `site.baseurl` as the project name for project pages if none is set

## Usage

Usage of this gem is pretty straight-forward. Add it to your bundle like this:

```ruby
gem 'jekyll-github-metadata'
```

Now add it to your `_config.yml`:

```yaml
gems:
  - jekyll-github-metadata
```

Then go ahead and run `bundle install`. Once you've done that jekyll-github-metadata will run when you run Jekyll.


## Further reading

* [Authentication](authentication.md)
* [Configuration](configuration.md)
* [Edit on GitHub link](edit-on-github-link.md)
