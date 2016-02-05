github-metadata, a.k.a. `site.github`
=====================================

[![Build Status](https://travis-ci.org/jekyll/github-metadata.svg?branch=test-site)](https://travis-ci.org/jekyll/github-metadata)

Access `site.github` metadata anywhere (...you have an internet connection).

**First, a very special thanks to GitHub (especially Ben Balter and their legal team) for allowing me to open-source this code.** :heart:

## Usage

Usage of this gem is pretty straight-forward. Add it to your bundle like this:

```ruby
gem 'jekyll-github-metadata'
```

Then go ahead and run `bundle install`. Once you've done that, add your repo & the gem to your `_config.yml`:

```yaml
# or use PAGES_REPO_NWO in the env
repository: me/super-cool-project
gems: ['jekyll-github-metadata']
```

Then run `jekyll` like you normally would and your `site.github.*` fields should fill in like normal.

## Authentication

For some fields, like `cname`, you need to authenticate yourself. Luckily it's pretty easy. You have 2 options:

### 1. `JEKYLL_GITHUB_TOKEN`

These tokens are easy to use and delete so if you move around from machine-to-machine, we'd recommend this route. Set `JEKYLL_GITHUB_TOKEN` to your access token (with `public_repo` scope) when you run `jekyll`, like this:

```bash
$ JEKYLL_GITHUB_TOKEN=123abc [bundle exec] jekyll serve
```

### 2. `~/.netrc`

If you prefer to use the good ol' `~/.netrc` file, just make sure the `netrc` gem is bundled and run `jekyll` like normal. So if I were to add it, I'd add `gem 'netrc'` to my `Gemfile`, run `bundle install`, then run `bundle exec jekyll build`. The `machine` directive should be `api.github.com`.

### 3. Octokit

We use [Octokit](https://github.com/octokit/octokit.rb) to make the appropriate API responses to fetch the metadata. You may set `OCTOKIT_ACCESS_TOKEN` and it will be used to access GitHub's API.

```bash
$ OCTOKIT_ACCESS_TOKEN=123abc [bundle exec] jekyll serve
```

## Overrides

- `PAGES_REPO_NWO` – overrides `site.repository` as the repo name with owner to fetch (e.g. `jekyll/github-metadata`)

Some `site.github` values can be overridden by environment variables.

- `JEKYLL_BUILD_REVISION` – the `site.github.build_revision`, git SHA of the source site being built. (default: `git rev-parse HEAD`)
- `PAGES_ENV` – the `site.github.pages_env` (default: `dotcom`)
- `PAGES_API_URL` – the `site.github.api_url` (default: `https://api/github.com`)
- `PAGES_HELP_URL` – the `site.github.help_url` (default: `https://help.github.com`)
- `PAGES_GITHUB_HOSTNAME` – the `site.github.hostname` (default: `https://github.com`)
- `PAGES_PAGES_HOSTNAME` – the `site.github.pages_hostname` (default: `github.io`)

## Configuration

Working with `jekyll-github-metadata` and GitHub Enterprise? No sweat. You can configure which API endpoints this plugin will hit to fetch data.

- `SSL` – if "true", sets a number of endpoints to use `https://`, default: `"false"`
- `OCTOKIT_API_ENDPOINT` – the full hostname and protocol for the api, default: `https://api.github.com`
- `OCTOKIT_WEB_ENDPOINT` – the full hostname and protocol for the website, default: `https://github.com`
- `PAGES_PAGES_HOSTNAME` – the full hostname from where GitHub Pages sites are served, default: `github.io`.
- `NO_NETRC` – set if you don't want the fallback to `~/.netrc`

## License

MIT License, credit to GitHub, Inc. See [LICENSE](LICENSE) for more details.
