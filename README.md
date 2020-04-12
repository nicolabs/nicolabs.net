Source code for https://www.nicolabs.net

## Previewing locally

Run `bundle exec jekyll serve -d docs --livereload --drafts` to start a local server with live reload and drafts preview.

### Drafts

**Jekyll drafts** (articles in `_drafts/`) are *absolutely not ready* for publication. Some of them in `_drafts/` are *still* old documents I've never finished...
On the other hand, **articles tagged with _draft_** are published with a special mention so that they hopefully can be useful to anybody : old drafts are slowly being published with this *draft* mention.
There are other mentions (unpublished, draft, good, stable, deprecated) to indicate articles' maturity.

See [Migrating from Drupal to Jekyll](_posts/Migrating-from-Drupal-to-Jekyll.md) for the explanation.
Most of the code lies in `_includes/maturity.html` and `_sass/nicolabs/*.scss` in order to :
- display the maturity label in each article's header
- advertise unstable articles in indexes (`index.html`, `tags.html`)
- remove drafts from the default feed

## Publishing

1. Update Ruby gems & build the final site without drafts :

    sudo bundle update
    bundle exec jekyll serve -d docs

2. Add, commit & push files [into the *master* git branch](https://help.github.com/en/github/working-with-github-pages/about-github-pages#publishing-sources-for-github-pages-sites), including the `docs` directory (`_site` directory renamed for github pages)

See [help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/) for more detailed instructions, including installation of prerequisites.
