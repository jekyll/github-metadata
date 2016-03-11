github-metadata, a.k.a. `site.github`
=====================================

[![Build Status](https://travis-ci.org/jekyll/github-metadata.svg?branch=test-site)](https://travis-ci.org/jekyll/github-metadata)

Access `site.github` metadata anywhere (...you have an internet connection).

## Usage

Usage of this gem is pretty straight-forward. Add it to your gemfile like this:

```ruby
gem 'jekyll-github-metadata'
```

Then go ahead and run `bundle install`. Once you've done that, add your repo & the gem to your `_config.yml`:

```yaml
# or use PAGES_REPO_NWO in the env <-- what does this mean?
repository: me/super-cool-project
gems: ['jekyll-github-metadata']
```

Then run `jekyll` like you normally would and your `site.github.*` fields should fill in like normal.

## Authentication

For some fields, like `cname`, you need to authenticate yourself. Luckily it's pretty easy. You have 3 options:

### 1. `JEKYLL_GITHUB_TOKEN`

To generate a new personal access token on GitHub.com:

- Open [https://github.com/settings/tokens/new][ghtoken]
- Select the scope _public_repository_, and add a description.
- Confirm and save the settings.

#### Encrypt the GitHub Token for Jekyll?

With the GitHub token created, you can now pass it to the NAMEHERE command-line tool, which adds the encrypted value to a file in your repository. To encrypt the token and add it to the `.config.yml` file in your cloned repository:

- Move into the same directory as `env.global`.
- Run the following command, replacing `<token>` with the GitHub token from the previous step.

```
$ ci encrypt GH_TOKEN=<token> --add env.global
```

These tokens are easy to use and delete so if you move around from machine-to-machine, we'd recommend this route. Set `JEKYLL_GITHUB_TOKEN` to your access token (with `public_repo` scope) when you run `jekyll`, like this:

```bash
$ JEKYLL_GITHUB_TOKEN=abc123def456 [bundle exec] jekyll serve
```

- Verify the script added the `secure` global environment variable to `.config.yml`:
+
[source, yaml]
----
env:
  global:
    secure: [YOUR-ENCRYPTED-TOKEN]
----
+

- Commit all changes, and push to GitHub.

```
$ git push
```

#### Verify the Configuration

To verify if you have configured the repository correctly, open https://your-ci.org and verify that CI starts, and subsequently finishes processing the job.

CI should place the built site into the _gh-pages_ branch upon completion.


### 2. `~/.netrc`

A `.netrc` file contains login and initialization information used by an auto-login process.  If you prefer to use the good ol' `~/.netrc` file, just make sure the [`netrc`][netrc] gem is bundled. Add `gem 'netrc'` to your `Gemfile`, run `bundle install`, then run `bundle exec jekyll build`. It generally resides in the user’s home directory, but a location outside of the home directory can be set using the environment variable NETRC.

The `machine name` identify a remote machine name. The auto-login process searches the .netrc file for a machine token that matches the remote machine specified on the ftp command line or as an open command argument. Once a match is made, the subsequent .netrc tokens are processed, stopping when the end of file is reached or another machine or a default token is encountered.

The `machine name` directive should be `api.github.com`.

```bash
$ api.github.com [bundle exec] jekyll serve
```

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

## GitHub Enterprise Configuration

Working with `jekyll-github-metadata` and GitHub Enterprise? No sweat. You can configure which API endpoints this plugin will hit to fetch data.

- `SSL` – if "true", sets a number of endpoints to use `https://`, default: `"false"`
- `OCTOKIT_API_ENDPOINT` – the full hostname and protocol for the api, default: `https://api.github.com`
- `OCTOKIT_WEB_ENDPOINT` – the full hostname and protocol for the website, default: `https://github.com`
- `PAGES_PAGES_HOSTNAME` – the full hostname from where GitHub Pages sites are served, default: `github.io`.
- `NO_NETRC` – set if you don't want the fallback to `~/.netrc`

## License

MIT License, credit to GitHub, Inc. See [LICENSE](LICENSE) for more details.

<links>

[ghtoken]: https://github.com/settings/tokens/new
[netrc]: https://rubygems.org/gems/netrc/versions/0.11.0
