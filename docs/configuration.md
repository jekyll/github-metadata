## Configuration

In order for jekyll-github-metadata to know what metadata to fetch it must
be able to determine the repository NWO (name with owner, e.g. `jekyll/jekyll-github-metadata`) to ask GitHub about.

The easiest way to accomplish this is by setting an "origin" remote with a
github.com URL. If you ran `git clone` from GitHub, this is almost 100% the
case & no further action is needed. If you run `git remote -v` in your
repository, you should see your repo's URL. However, this only works if the
environment variable `JEKYLL_ENV` is either `development` or `test`.
The default value of `JEKYLL_ENV` is `development`.

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

## Overrides

- `PAGES_REPO_NWO` – overrides `site.repository` as the repo name with owner to fetch (e.g. `jekyll/github-metadata`)

Some `site.github` values can be overridden by environment variables.

- `JEKYLL_BUILD_REVISION` – the `site.github.build_revision`, git SHA of the source site being built. (default: `git rev-parse HEAD`)
- `PAGES_ENV` – the `site.github.pages_env` (default: `development`)
- `PAGES_API_URL` – the `site.github.api_url` (default: `https://api.github.com`)
- `PAGES_HELP_URL` – the `site.github.help_url` (default: `https://docs.github.com`)
- `PAGES_GITHUB_HOSTNAME` – the `site.github.hostname` (default: `github.com`)
- `PAGES_PAGES_HOSTNAME` – the `site.github.pages_hostname` (default: `github.io`)
- `NO_NETRC` – set if you don't want the fallback to `~/.netrc`

## Using with GitHub Enterprise

Working with `jekyll-github-metadata` and GitHub Enterprise? No sweat. You can configure which API endpoints this plugin will hit to fetch data.

- `SSL` – if "true", sets a number of endpoints to use `https://`, default: `"false"`
- `OCTOKIT_API_ENDPOINT` – the full hostname and protocol for the api, default: `https://api.github.com`
- `OCTOKIT_WEB_ENDPOINT` – the full hostname and protocol for the website, default: `https://github.com`
- `PAGES_PAGES_HOSTNAME` – the full hostname from where GitHub Pages sites are served, default: `github.io`.
