github-metadata, a.k.a. `site.github`
=====================================

[![Build Status](https://travis-ci.org/jekyll/github-metadata.svg?branch=test-site)](https://travis-ci.org/jekyll/github-metadata)

Access `site.github` metadata anywhere (...you have an internet connection).

## Usage

Usage of this gem is pretty straight-forward. Add it to your bundle like this:

```ruby
gem 'jekyll-github-metadata'
```

Now add it to your `_config.yml`:

```yaml
gems: ['jekyll-github-metadata']
```

Then go ahead and run `bundle install`. Once you've done that jekyll-github-metadata will run when you run Jekyll.

In order for jekyll-github-metadata to know what metadata to fetch it must
be able to determine the repository NWO (name with owner, e.g. `jekyll/jekyll-github-metadata`) to ask GitHub about.

The easiest way to accomplish this is by setting an "origin" remote with a
github.com URL. If you ran `git clone` from GitHub, this is almost 100% the
case & no further action is needed. If you run `git remote -v` in your
repository, you should see your repo's URL.

If you don't have a git remote available, you have two other options:

1. Set the environment variable `PAGES_REPO_NWO` to your repository name
   with owner, e.g. `"jekyll/github-metadata"`. This is useful if you don't
   want to commit your repository to your git history.
2. Add your repository name with organization to your site's configuration
   in the `repository` key.

```yaml
repository: username/repo-name
```

"NWO" stands for "name with owner." It is GitHub lingo for the username of
the owner of the repository plus a forward slash plus the name of the
repository, e.g. 'parkr/blog', where 'parkr' is the owner and 'blog' is the
repository name.

Your `site.github.*` fields should fill in like normal. If you run Jekyll
with the `--verbose` flag, you should be able to see all the API calls
made.

## Authentication

For some fields, like `cname`, you need to authenticate yourself. Luckily it's pretty easy. First, you need to generate a personal access token (an oauth token will work too but it's good to have a token for each purpose so you can revoke them later without breaking everything):

To generate a new personal access token on GitHub.com:

- Open https://github.com/settings/tokens/new
- Select the scope *public_repository*, and add a description.
- Confirm and save the settings. Copy the token you see on the page.

Once you have your token, you have three ways to pass it to this program:

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
- `PAGES_ENV` – the `site.github.pages_env` (default: `development`)
- `PAGES_API_URL` – the `site.github.api_url` (default: `https://api.github.com`)
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
