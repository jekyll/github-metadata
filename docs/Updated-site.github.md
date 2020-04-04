## Using `site.github`

Common repository information, such as the project name and description, is available to Jekyll sites using `jekyll-github-metadata` including GitHub Pages sites.

#### Usage

Repository metadata is exposed to your Jekyll site's configuration in the `site.github` namespace.

Simply, reference any of the below keys as you would any other site configuration value present in your `_config.yml` file, prefacing the key with `site.github`.

For example, to list a project's name, you might write something like `The project is called {{ site.github.project_title }}` or to list an organization's open source repositories, you might use the following:

<!-- {% raw %} -->
```liquid
{% for repository in site.github.public_repositories %}
  * [{{ repository.name }}]({{ repository.html_url }})
{% endfor %}
```
<!-- {% endraw %} -->

#### Available repository metadata

The following sample information is exposed to Jekyll templates in the `site.github` namespace:

```text
{
    "versions": {
        "jekyll": <version>,
        "kramdown": <version>,
        "liquid": <version>,
        "maruku": <version>,
        "rdiscount": <version>,
        "redcarpet": <version>,
        "RedCloth": <version>,
        "jemoji": <version>,
        "jekyll-mentions": <version>,
        "jekyll-redirect-from": <version>,
        "jekyll-sitemap": <version>,
        "github-pages": <version>,
        "ruby": <version>"
    },
    "hostname": "github.com",
    "pages_hostname": "github.io",
    "api_url": "https://api.github.com",
    "help_url": "https://help.github.com",
    "environment": "dotcom",
    "pages_env": "dotcom",
    "public_repositories": [ Repository Objects ],
    "organization_members": [ User Objects ],
    "build_revision": "cbd866ebf142088896cbe71422b949de7f864bce",
    "project_title": "metadata-example",
    "project_tagline": "A GitHub Pages site to showcase repository metadata",
    "owner_name": "github",
    "owner_url": "https://github.com/github",
    "owner_gravatar_url": "https://github.com/github.png",
    "repository_url": "https://github.com/github/metadata-example",
    "repository_nwo": "github/metadata-example",
    "repository_name": "metadata-example",
    "zip_url": "https://github.com/github/metadata-example/zipball/gh-pages",
    "tar_url": "https://github.com/github/metadata-example/tarball/gh-pages",
    "clone_url": "https://github.com/github/metadata-example.git",
    "releases_url": "https://github.com/github/metadata-example/releases",
    "issues_url": "https://github.com/github/metadata-example/issues",
    "wiki_url": "https://github.com/github/metadata-example/wiki",
    "language": null,
    "is_user_page": false,
    "is_project_page": true,
    "show_downloads": true,
    "url": "http://username.github.io/metadata-example", // (or the CNAME)
    "baseurl": "/metadata-example",
    "contributors": [ User Objects ],
    "releases": [ Release Objects ],
    "latest_release": [ Release Object ],
    "private": false,
    "archived": false,
    "disabled": false,
    "license": {
      "key": "mit",
      "name": "MIT License",
      "spdx_id": "MIT",
      "url": "https://api.github.com/licenses/mit"
    },
    "source": {
      "branch": "gh-pages",
      "path": "/"
    }
}
```
