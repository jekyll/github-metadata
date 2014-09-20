github-metadata
===============

Your site's `site.github` repo metadata.

**First, a very special thanks to GitHub (especially Ben Balter and their legal team) for allowing me to open-source this code.** :heart:

## Usage

Usage of this gem is pretty straight-forward. Add it to your bundle like this:

```ruby
gem 'jekyll-github-metadata'
```

Then go ahead and run `bundle install`. Once you've done that, add your repo & the gem to your `_config.yml`:

```yaml
repository: me/super-cool-project
gems: ['jekyll-github-metadata']
```

Then run `jekyll` like you normally would and your `site.github.*` fields should fill in like normal.

