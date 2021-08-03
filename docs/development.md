## Development
> Guide to local development of this plugin

### Installation

#### Requirements

- Ruby
- Bundler

#### Install system dependencies

- Install Ruby - see the [Downloads](https://www.ruby-lang.org/en/downloads/) page.
- Install Bundler - see [Bundler](https://bundler.io/) homepage.

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

## Usage

See the [script](/script/) directory.

### Format

Check formatting.

```bash
$ script/fmt
```

Fix formatting issues.

```bash
$ script/fmt -a
```

### Open interactive console

```bash
$ script/console
```

### Test

Run all unit tests.

```bash
$ script/test
```

Run specific unit tests.

```bash
$ script/test PATH
$ # e.g.
$ script/test spec/owner_spec.rb
```

### Test site

Run dev server for sample Jekyll site.

```bash
$ script/test-site
```

Then open in the browser at

- http://127.0.0.1:4000

## Release

Run tests, formatting and create a release.

```bash
$ script/release
```
