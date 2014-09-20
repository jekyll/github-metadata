github-metadata
===============

Access `site.github` metadata anywhere (...you have an internet connection).

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

## Authentication

For some fields, like `cname`, you need to authenticate yourself. Luckily it's pretty easy. You have 2 options:

### 1. `JEKYLL_GITHUB_TOKEN`

These tokens are easy to use and delete so if you move around from machine-to-machine, I'd recommend this route. Set `JEKYLL_GITHUB_TOKEN` to your access token when you run `jekyll`, like this:

```bash
$ JEKYLL_GITHUB_TOKEN=123abc jekyll serve
```

### 2. `~/.netrc`

If you prefer to use the good ol' `~/.netrc` file, just make sure the `netrc` gem is bundled and run `jekyll` like normal. So if I were to add it, I'd add `gem 'netrc'` to my `Gemfile`, run `bundle install`, then run `bundle exec jekyll build`. The `machine` directive should be `api.github.com`.

## License

MIT License, copyright GitHub 2014.
