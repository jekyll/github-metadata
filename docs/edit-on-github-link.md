## Edit on GitHub link

The plugin also makes a tag available that generates links to edit the current page on GitHub.

### To generate a link

```liquid
<p>This site is open source. {% github_edit_link "Improve this page" %}</p>
```

Produces:

```html
<p>This site is open source. <a href="https://github.com/benbalter/jekyll-edit-link/edit/master/README.md">Improve this page</a></p>
```

### To generate a path

If you'd prefer to build your own link, simply don't pass link text

```liquid
<p>This site is open source. <a href="{% github_edit_link %}">Improve this page</a></p>
```

Produces:


```html
<p>This site is open source. <a href="https://github.com/benbalter/jekyll-edit-link/edit/master/README.md">Improve this page</a></p>
```
