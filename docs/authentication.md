## Authentication

For some fields, like `cname`, you need to authenticate yourself. Luckily it's pretty easy. First, you need to generate a personal access token (an oauth token will work too but it's good to have a token for each purpose so you can revoke them later without breaking everything):

To generate a new personal access token on GitHub.com:

- Open https://github.com/settings/tokens/new
- Select the scope *public_repository*, and add a description.
- Confirm and save the settings. Copy the token you see on the page.

Once you have your token, you have three ways to pass it to this program:

### 1. `JEKYLL_GITHUB_TOKEN`

These tokens are easy to use and delete so if you move around from machine-to-machine, we'd recommend this route. Set `JEKYLL_GITHUB_TOKEN` to your access token (with `public_repo` scope for public repositories or `repo` scope for private repositories) when you run `jekyll`, like this:

```bash
$ JEKYLL_GITHUB_TOKEN=123abc [bundle exec] jekyll serve
```

### 2. `~/.netrc`

If you prefer to use the good ol' `~/.netrc` file, just make sure the `netrc` gem is bundled and run `jekyll` like normal. So if I were to add it, I'd add `gem 'netrc'` to my `Gemfile`, run `bundle install`, then run `bundle exec jekyll build`. The `machine` directive should be `api.github.com`.

```netrc
machine api.github.com
    login github-username
    password 123abc-your-token
```

### 3. Octokit

We use [Octokit](https://github.com/octokit/octokit.rb) to make the appropriate API responses to fetch the metadata. You may set `OCTOKIT_ACCESS_TOKEN` and it will be used to access GitHub's API.

```bash
$ OCTOKIT_ACCESS_TOKEN=123abc [bundle exec] jekyll serve
```

## DotEnv

Rather than prefixing your shell commands with the environmental variables all the time, you can use the
[Dotenv](https://github.com/bkeepers/dotenv) gem. Simply install it by adding it to your Gemfile, then create a `.env` file and populate it with your `JEKYLL_GITHUB_TOKEN` or `OCTOKIT_ACCESS_TOKEN`. Be sure you do not commit your `.env` file!
