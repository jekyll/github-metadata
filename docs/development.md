## Development

Guide to local development of this plugin

### Installation

#### Requirements

- Ruby
- Bundler

#### Install system dependencies

- Install Ruby - see the [Downloads](https://www.ruby-lang.org/en/downloads/) page.
- Install Bundler - see the [Bundler](https://bundler.io/) homepage.

#### Clone

Clone the repo, or your fork.

```bash
$ git clone git@github.com:jekyll/github-metadata.git
$ cd github-metadata
```

#### Install project dependencies

Configure Bundler.

```bash
$ bundle config set --local path vendor/bundle
```

Install gems.

```bash
$ bundle install
```

Or, for a faster install.

```bash
$ script/bootstrap
```

### Usage

See the [script](/script/) directory.

#### Format

Check for code formatting issues - recommended before you commit.

```bash
$ script/fmt
```

Fix formatting issues.

```bash
$ script/fmt -a
```

#### Open interactive console

```bash
$ script/console
```

#### Test

Run all unit tests.

```bash
$ script/test
```

Run a target unit test file by specifying a path.

```bash
$ script/test spec/owner_spec.rb
```

See some recommended flags below.

Run tests in the order they are written (not a random order).

```bash
$ script/test --order defined
```

Run tests in the same random order as a previous run.

```bash
$ script/test --seed 12345
```

Run tests with verbose trace logs.

```bash
$ script/test --format documentation
```

#### Start dev server

Preview the plugin in Jekyll by running the repo's sample Jekyll site.

```bash
$ script/test-site
```

Then open in the browser at:

- http://127.0.0.1:4000

### Release

Run tests, formatting and create a release.

```bash
$ script/release
```
